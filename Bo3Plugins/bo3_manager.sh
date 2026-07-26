#!/bin/bash

# Script generado por gemini

# Como usar:
# - Descargar archivos de Clean Ops (https://www.cleanops.dev/)
# - Descargar archivos de T7 Path. QEPD Alyssa. (https://github.com/Scroptss/T7Patch)
# - Descargar archivos y seguir indicaciones de Ranku Up Mod (https://insanux.com/bo3-rankup-mod/)
# - Crear colocarlos en una ruta conocida y modificar las variables de entorno

# ==========================================
# Variables de Entorno (Modifica las rutas)
# ==========================================
BO3_DIR="/path/to/SteamLibrary/steamapps/common/Call of Duty Black Ops III"
PLUGINS_BASE_DIR="/path/to/Bo3Plugins/"

# Carepta con archivos de t7 patch y rankup mod
T7_DIR="${PLUGINS_BASE_DIR}/t7 patch"

# Archivos con dll de clean ops
CLEAN_OPS_DIR="${PLUGINS_BASE_DIR}/Clean Ops"

# ==========================================
# Manejo de Errores
# ==========================================
set -e # Detener el script si un comando falla

if [[ ! -d "$BO3_DIR" ]]; then
    echo "[ERROR] El directorio raíz de BO3 no existe: $BO3_DIR"
    exit 1
fi

if [[ ! -d "$T7_DIR" ]] || [[ ! -d "$CLEAN_OPS_DIR" ]]; then
    echo "[ERROR] Los directorios de los mods no existen. Verifica PLUGINS_BASE_DIR."
    exit 1
fi

# ==========================================
# Lógica de Estado
# ==========================================
clean_environment() {
    echo "Limpiando entorno raíz de BO3..."
    # Remover rastros de T7 Patch
    rm -f "${BO3_DIR}/dsound.dll"
    rm -f "${BO3_DIR}/t7patch.conf"
    rm -f "${BO3_DIR}/t7patch.dll"

    # Si no se desea unar rank up mod deberás modificar esto
    rm -rf "${BO3_DIR}/plugins"
    rm -f "${BO3_DIR}/t7patchloader.asi"
    
    # Remover rastros de Clean Ops
    rm -f "${BO3_DIR}/d3d11.dll"
}

apply_mod() {
    local source_dir=$1
    echo "Aplicando archivos desde: $(basename "$source_dir")"
    cp -r "${source_dir}/"* "${BO3_DIR}/"
}

case "$1" in
    --zombies)
        clean_environment
        apply_mod "$T7_DIR"
        ;;
    --multiplayer)
        clean_environment
        apply_mod "$CLEAN_OPS_DIR"
        ;;
    *)
        echo "Uso incorrecto. Argumentos válidos: --zombies | --multiplayer"
        exit 1
        ;;
esac

# ==========================================
# Ejecución (Delegación a Steam URI)
# ==========================================
echo "Lanzando Call of Duty: Black Ops III..."
xdg-open steam://rungameid/311210
