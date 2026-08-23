# Define la ruta de tu repositorio
DOTFILES_DIR="$HOME/packages/dotfiles/gnome-config"
mkdir -p "$DOTFILES_DIR"

# Volcado de atajos del gestor de ventanas (Mutter)
dconf dump /org/gnome/desktop/wm/keybindings/ > "$DOTFILES_DIR/wm.dconf"

# Volcado de atajos del Shell (GNOME Shell)
dconf dump /org/gnome/shell/keybindings/ > "$DOTFILES_DIR/shell.dconf"

# Volcado de atajos específicos de composición
dconf dump /org/gnome/mutter/keybindings/ > "$DOTFILES_DIR/mutter.dconf"

# Volcado de teclas multimedia y atajos de comandos personalizados
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > "$DOTFILES_DIR/media.dconf"

echo "[OK] Volcado de keybinds completado en $DOTFILES_DIR"
