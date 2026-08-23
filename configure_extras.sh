#!/bin/bash
set -euo pipefail
echo "============================================================"
echo "[Script] Instalando extensiones gnome, apps, y utilidades"
echo "============================================================"
sudo pacman -Syu paru --needed -y

# Instalar paquetes
paru -Syu \
gnome-shell-extension-appindicator \
gnome-shell-extension-blur-my-shell \
papirus-icon-theme \
wl-clipboard \
audiosource \
nokkvi-bin \
ttf-cascadia-code-nerd \
ttf-ms-fonts \
ttf-wps-fonts \
onlyoffice-bin \
libreoffice-fresh \
stirling-pdf-desktop \
brave-origin-bin \
fish \
ufw \
eza \
bat \
zoxide \
tmux \
yazi \
fzf \
snapper \
snap-pac \
btrfs-assistant \
syncthing \
git \
git-delta \
base-devel \
mission-center \
neovim \
tree-sitter-cli \
starship \
fnm \
rustup \
dotnet-sdk-bin \
dotnet-runtime-bin \
aspnet-runtime-bin \
jdk-openjdk \
maven \
netbeans \
dbeaver \
mariadb \
postgresql \
uv \
podman \
podman-docker \
podman-compose \
dia-git \
obsidian \
filezilla \
cmake \
cachyos-gaming-meta \
steam \
heroic-games-launcher \
--needed -y

# Ruta relativa del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "============================================================"
echo "[Script] Configurando ufw"
echo "============================================================"
sudo systemctl enable --now ufw
sudo ufw default deny
sudo ufw allow from 192.168.1.0/24
sudo ufw allow Deluge
sudo ufw limit ssh



echo "============================================================"
echo "[Script] Estableciendo fish como shell predeterminada (reiniciar para ver efecto)"
echo "============================================================"
chsh -s /usr/bin/fish
FISH_CFG_DIR="$SCRIPT_DIR/.config/fish"
rm -rf "$HOME/.config/fish"
cp -r "$FISH_CFG_DIR" "$HOME/.config"

rm -rf "$HOME/.config/starship.toml"
STARSHIP_CFG="$SCRIPT_DIR/.config/starship.toml"
cp -r "$STARSHIP_CFG" "$HOME/.config"


echo "============================================================"
echo "[Script] Configurando NodeJS"
echo "============================================================"
fnm install 24

echo "============================================================"
echo "[Script] Configurando Rust"
echo "============================================================"
# Instalar y configurar rust
rustup default stable

echo "============================================================"
echo "[Script] Habilitando syncthing"
echo "============================================================"
sudo systemctl enable --now syncthing@$USER

echo "============================================================"
echo "[Script] Copiando dots"
echo "============================================================"
rm -rf "$HOME/.config/nvim" "$HOME/.config/kitty"  "$HOME/.config/tmux" "$HOME/.tmux.conf"
cp -r "$SCRIPT_DIR/.config/nvim" "$HOME/.config"
cp -r "$SCRIPT_DIR/.config/kitty" "$HOME/.config"
cp -r "$SCRIPT_DIR/.config/tmux" "$HOME/.config"
cp -r "$SCRIPT_DIR/.gitconfig" "$HOME/"
cp -r "$SCRIPT_DIR/wallpaper.jpeg" "$HOME/Pictures/"
cp -r "$SCRIPT_DIR/wallpaper2.jpeg" "$HOME/Pictures/"

echo "============================================================"
echo "[Script] Descargando tmux TPM"
echo "============================================================"
# Descargar tpm
git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

echo "============================================================"
echo "[Script] Configurando git"
echo "============================================================"
# [ -t 0 ] evalúa si el descriptor de archivo 0 (stdin) está conectado a una terminal
if [ -t 0 ]; then
    # --------------------------------------------------------------------------
    # 1. Identidad de Git
    # --------------------------------------------------------------------------
    # -r evita que bash interprete contrabarras (\) como secuencias de escape
    # -p imprime el mensaje en la misma línea
    read -rp "¿Deseas configurar la identidad global de Git ahora? [s/N]: " prompt_git
    git_email="" # Inicializar para usarla en SSH posteriormente
    
    case "${prompt_git}" in
        [sS]|[sS][iI]|[yY]|[yY][eE][sS])
            git_name=""
            while [[ -z "${git_name}" ]]; do
                read -rp "Ingresa tu nombre (user.name): " git_name
            done

            while [[ -z "${git_email}" ]]; do
                read -rp "Ingresa tu correo (user.email): " git_email
            done

            git config --global user.name "${git_name}"
            git config --global user.email "${git_email}"
            echo "[OK] Identidad de Git configurada."
            ;;
        *)
            echo "[INFO] Omitiendo configuración de identidad de Git."
            ;;
    esac

    # --------------------------------------------------------------------------
    # 2. Generación de Clave SSH
    # --------------------------------------------------------------------------
    read -rp "¿Deseas generar una nueva clave SSH (Ed25519)? [s/N]: " prompt_ssh
    case "${prompt_ssh}" in
        [sS]|[sS][iI]|[yY]|[yY][eE][sS])
            SSH_FILE="$HOME/.ssh/id_ed25519"
            
            # Bloqueo de seguridad: Evitar destrucción de claves existentes
            if [ -f "$SSH_FILE" ]; then
                echo "[WARN] La clave $SSH_FILE ya existe. Omitiendo para evitar pérdida de datos."
            else
                # Si se saltó la config de Git, pedir el correo para la etiqueta de la clave
                ssh_email="${git_email:-}"
                while [[ -z "${ssh_email}" ]]; do
                    read -rp "Ingresa el correo para asociar a la clave SSH: " ssh_email
                done
                
                echo "[INFO] Generando clave SSH Ed25519. Puedes dejar la contraseña en blanco (Enter) o establecer una."
                
                # Explicación de los flags:
                # -t ed25519 : Define el algoritmo.
                # -C "$ssh_email" : Etiqueta (Comment) adjunta a la clave pública para fácil identificación.
                # -f "$SSH_FILE" : Fuerza la ruta del archivo, evitando que ssh-keygen pregunte dónde guardarlo.
                ssh-keygen -t ed25519 -C "$ssh_email" -f "$SSH_FILE"
                
                echo -e "\n[OK] Clave pública generada. Lista para añadir a GitHub/GitLab:"
                cat "${SSH_FILE}.pub"
                echo "" # Salto de línea limpio
            fi
            ;;
        *)
            echo "[INFO] Omitiendo generación de clave SSH."
            ;;
    esac
else
    echo "[WARN] Ejecución no interactiva (sin TTY detectado). Omitiendo prompts de Git/SSH."
fi


echo "============================================================"
echo "[Script] Configurando GNOME"
echo "============================================================"

# ==============================================================================
# INICIALIZACIÓN DEL ENTORNO D-BUS (Requerido para gsettings/dconf)
# ==============================================================================
if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
    _USER_ID=$(id -u)
    _BUS_PATH="/run/user/${_USER_ID}/bus"

    if [ -S "$_BUS_PATH" ]; then
        # Escenario 1: El socket existe (TTY, SSH, sesión logind), lo vinculamos.
        export DBUS_SESSION_BUS_ADDRESS="unix:path=${_BUS_PATH}"
        echo "[INFO] D-Bus vinculado al socket existente: $_BUS_PATH"
    else
        # Escenario 2: No hay demonio D-Bus (entorno chroot o aislado).
        # Verificamos si dbus-run-session está disponible para levantar un bus efímero.
        if command -v dbus-run-session >/dev/null 2>&1; then
            echo "[INFO] D-Bus ausente. Relanzando el script bajo dbus-run-session..."
            # exec reemplaza el proceso actual. El script se ejecuta de nuevo desde cero
            # pero esta vez con un entorno D-Bus inyectado automáticamente.
            exec dbus-run-session -- "$0" "$@"
        else
            echo "[ERROR] No se pudo encontrar ni iniciar un bus de sesión D-Bus." >&2
            echo "[ERROR] dconf/gsettings fallarán. Abortando." >&2
            exit 1
        fi
    fi
fi

# Configurar boton de log out gnome
gsettings set org.gnome.shell always-show-log-out true

# 1. Desactivar aceleración de mouse (perfil plano / 1:1)
gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'

# 2. Mostrar botones de minimizar, maximizar y cerrar en las ventanas
# Nota: La sintaxis define "izquierda:derecha" separadas por dos puntos.
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

# 3. Workspaces estáticos y fijados en 4
# Desactiva la asignación dinámica automática
gsettings set org.gnome.mutter dynamic-workspaces false
# Define el número fijo de áreas de trabajo
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4

# 4. Multitasking: Desactivar resize/edge tiling (redimensionar al arrastrar a bordes)
gsettings set org.gnome.mutter edge-tiling false

# 5. Multi-monitor: Mantener workspaces en todas las pantallas
gsettings set org.gnome.mutter workspaces-only-on-primary false

# 6. App Switching (Alt+Tab): Limitar al workspace activo
gsettings set org.gnome.shell.app-switcher current-workspace-only true

# 7. Estabelcer tema oscuro
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Cambiar color de acento
gsettings set org.gnome.desktop.interface accent-color 'red'

# Modo claro
gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Pictures/wallpaper.jpeg"

# Modo oscuro (GNOME 42+)
gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/Pictures/wallpaper.jpeg"

# 8. Activar extensiones
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com
gnome-extensions enable blur-my-shell@aunetx



DOTFILES_DIR="$SCRIPT_DIR/gnome-config"

# Mapeo relacional: Ruta en dconf -> Archivo INI
declare -A KEYBINDS=(
  ["/org/gnome/desktop/wm/keybindings/"]="wm.dconf"
  ["/org/gnome/shell/keybindings/"]="shell.dconf"
  ["/org/gnome/mutter/keybindings/"]="mutter.dconf"
  ["/org/gnome/settings-daemon/plugins/media-keys/"]="media.dconf"
)

echo "Iniciando restauración de keybinds de GNOME..."

for path in "${!KEYBINDS[@]}"; do
  file="${DOTFILES_DIR}/${KEYBINDS[$path]}"
  
  if [[ -f "$file" ]]; then
    # El comando load inyecta el contenido del archivo en la ruta especificada.
    # Es idempotente: si se ejecuta múltiples veces, el estado final es el mismo.
    dconf load "$path" < "$file"
    echo "[OK] Rutas inyectadas en: $path"
  else
    echo "[WARN] Archivo no encontrado: $file. Omitiendo ruta $path." >&2
  fi
done

echo "Restauración completada."


CONFIG_FILE="$SCRIPT_DIR/gnome-config/app-folders.dconf"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "[ERROR] Archivo de configuración no encontrado: $CONFIG_FILE" >&2
    exit 1
fi

echo "Restaurando estructura de carpetas de GNOME..."

# Carga masiva e idempotente de la topología de carpetas
dconf load /org/gnome/desktop/app-folders/ < "$CONFIG_FILE"

echo "[OK] Carpetas de aplicaciones restauradas con éxito."
