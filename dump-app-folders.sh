#!/usr/bin/env bash
set -euo pipefail

# Resuelve la ruta absoluta del repositorio de dotfiles donde reside este script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/gnome-config"

mkdir -p "$CONFIG_DIR"

# Volcar la rama completa de app-folders
# Captura tanto el índice (folder-children) como los nodos de configuración (name, apps)
dconf dump /org/gnome/desktop/app-folders/ > "$CONFIG_DIR/app-folders.dconf"

echo "[OK] Estructura de carpetas extraída en $CONFIG_DIR/app-folders.dconf"
