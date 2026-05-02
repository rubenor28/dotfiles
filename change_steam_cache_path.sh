#!/bin/bash
# ==============================================================================
# configure_steam_cache.sh
# Propósito: Migrar y enlazar directorios de caché de Steam a almacenamiento secundario. Util para configuraciones con HDDs
# Generado con deepseek y gemini
# ==============================================================================

set -euo pipefail

usage() {
    echo "Uso: $0 --dest <RUTA_DESTINO> --steam <RUTA_STEAM_APPS> [--undo]"
    echo "Argumentos obligatorios:"
    echo "  --dest   Ruta del almacenamiento secundario (Ej: ~/SteamData)"
    echo "  --steam  Ruta de la librería origen (Ej: /media/1tb-hdd/SteamLibrary/steamapps)"
    echo "Opciones:"
    echo "  --undo   Revierte los cambios: restaura los datos al disco original y elimina enlaces."
    exit 1
}

error_exit() {
    echo "[ERROR FATAL] $1" >&2
    exit 1
}

expand_path() {
    local path="$1"
    path="${path/#\~/$HOME}"
    realpath -m "$path"
}

# ==============================================================================
# Configuración y Parámetros
# ==============================================================================

DEST_DIR=""
STEAM_DIR=""
UNDO_MODE=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dest)
            DEST_DIR="$2"
            shift 2
            ;;
        --steam)
            STEAM_DIR="$2"
            shift 2
            ;;
        --undo)
            UNDO_MODE=1
            shift 1
            ;;
        *)
            echo "[ERROR] Argumento desconocido: $1"
            usage
            ;;
    esac
done

if [[ -z "$DEST_DIR" ]] || [[ -z "$STEAM_DIR" ]]; then
    echo "[ERROR] Faltan argumentos obligatorios."
    usage
fi

DEST_DIR=$(expand_path "$DEST_DIR")
STEAM_DIR=$(expand_path "$STEAM_DIR")

echo "============================================================"
if [[ $UNDO_MODE -eq 1 ]]; then
    echo " Iniciando Rollback de Caché (VFS -> Almacenamiento Local)"
else
    echo " Inicializando Configuración de Caché en VFS"
fi
echo "------------------------------------------------------------"
echo " Destino (Almacenamiento Secundario): $DEST_DIR"
echo " Origen  (Librería Steam):            $STEAM_DIR"
echo "============================================================"

if [[ ! -d "$STEAM_DIR" ]]; then
    error_exit "El inodo de origen no existe o no es un directorio: $STEAM_DIR"
fi

# ==============================================================================
# 1. Liberar bloqueos de archivos
# ==============================================================================
if pgrep -x "steam" > /dev/null; then
    echo "[*] Interrumpiendo proceso daemon de Steam..."
    killall -9 steam 2>/dev/null || true
    sleep 2
else
    echo "[*] Steam inactivo. Sin bloqueos detectados."
fi

# ==============================================================================
# 2. Motores de Procesamiento
# ==============================================================================

process_directory() {
    local DIR_NAME="$1"
    local ORIGIN_PATH="$STEAM_DIR/$DIR_NAME"
    local DEST_PATH="$DEST_DIR/$DIR_NAME"

    echo "------------------------------------------------------------"
    echo "[*] Analizando capa: $DIR_NAME"

    mkdir -p "$DEST_PATH" || error_exit "Incapacidad de escribir en almacenamiento destino."
    chmod 755 "$DEST_PATH"

    if [[ -L "$ORIGIN_PATH" ]]; then
        local CURRENT_TARGET
        CURRENT_TARGET=$(readlink -f "$ORIGIN_PATH" || true)
        if [[ "$CURRENT_TARGET" == "$DEST_PATH" ]]; then
            echo "[✓] Topología correcta. $DIR_NAME ya enlazado."
            return 0
        else
            echo "[!] Enlace desactualizado. Purgando..."
            rm -f "$ORIGIN_PATH"
        fi
    elif [[ -d "$ORIGIN_PATH" ]]; then
        local IS_EMPTY=1
        for _ in "$ORIGIN_PATH"/* "$ORIGIN_PATH"/.[!.]* "$ORIGIN_PATH"/..?*; do
            IS_EMPTY=0; break
        done 2>/dev/null || true

        if [[ $IS_EMPTY -eq 0 ]]; then
            echo "[*] Datos detectados. Iniciando sincronización I/O..."
            if ! rsync -aP "$ORIGIN_PATH/" "$DEST_PATH/"; then
                error_exit "Fallo de E/S durante la sincronización."
            fi
        fi
        echo "[*] Destruyendo estructura original..."
        rm -rf "$ORIGIN_PATH"
    elif [[ -e "$ORIGIN_PATH" ]]; then
        rm -rf "$ORIGIN_PATH"
    fi

    echo "[*] Inyectando enlace simbólico..."
    ln -sfn "$DEST_PATH" "$ORIGIN_PATH"
}

restore_directory() {
    local DIR_NAME="$1"
    local ORIGIN_PATH="$STEAM_DIR/$DIR_NAME"
    local DEST_PATH="$DEST_DIR/$DIR_NAME"
    local TEMP_PATH="${ORIGIN_PATH}_restore_staging"

    echo "------------------------------------------------------------"
    echo "[*] Analizando capa para rollback: $DIR_NAME"

    if [[ ! -L "$ORIGIN_PATH" ]]; then
        echo "[!] $ORIGIN_PATH no es un enlace simbólico. Se omite para evitar corrupción de datos."
        return 0
    fi

    if [[ -d "$DEST_PATH" ]]; then
        echo "[*] Transfiriendo datos al volumen original (Staging temporal)..."
        
        # Uso de ruta temporal para evitar resolución cíclica del symlink por rsync
        if ! rsync -aP "$DEST_PATH/" "$TEMP_PATH/"; then
            rm -rf "$TEMP_PATH" # Limpieza en caso de fallo
            error_exit "Fallo de E/S durante la restauración de $DIR_NAME."
        fi

        echo "[*] Aplicando transacción atómica..."
        rm -f "$ORIGIN_PATH"          # Destruye el symlink
        mv "$TEMP_PATH" "$ORIGIN_PATH" # El directorio físico asume la ruta original
        
        echo "[*] Purgando caché del almacenamiento secundario..."
        rm -rf "$DEST_PATH"
        
        echo "[✓] Rollback exitoso para $DIR_NAME."
    else
        echo "[!] No existen datos remotos. Destruyendo enlace y recreando directorio vacío..."
        rm -f "$ORIGIN_PATH"
        mkdir -p "$ORIGIN_PATH"
        chmod 755 "$ORIGIN_PATH"
    fi
}

# ==============================================================================
# 3. Ejecución
# ==============================================================================

if [[ $UNDO_MODE -eq 1 ]]; then
    restore_directory "shadercache"
    restore_directory "compatdata"
    echo "============================================================"
    echo "[✓] Rollback del VFS completado. El estado original ha sido restaurado."
else
    process_directory "shadercache"
    process_directory "compatdata"
    echo "============================================================"
    echo "[✓] Configuración de Virtual File System completada."
fi
echo "============================================================"
