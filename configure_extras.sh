#!/bin/bash
echo "============================================================"
echo "[Script] Eliminado power profiles"
echo "============================================================"
sudo pacman -Rns power-profiles-daemon

echo "============================================================"
echo "[Script] Instalando extensiones gnome, apps, y utilidades"
echo "============================================================"
sudo pacman -Syu paru --needed -y

# Instalar paquetes
paru -Syu \
gnome-shell-extension-blur-my-shell \
gnome-shell-extension-hidetopbar-git \
gnome-shell-extension-just-perfection-desktop \
gnome-shell-extension-space-bar-git \
gnome-shell-extension-dash-to-dock \
gnome-shell-extension-appindicator \
wl-clipboard \
audiosource \
nokkvi-bin \
ttf-cascadia-code-nerd \
ttf-ms-fonts \
ttf-wps-fonts \
onlyoffice-bin \
libreoffice-fresh \
stirling-pdf-desktop \
alacritty \
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
tlp \
tlp-rdw \
tlp-pd \
tlpui \
syncthing \
git \
git-delta \
base-devel \
htop \
btop \
nvtop \
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
--needed -y

echo "============================================================"
echo "[Script] Configurando ufw"
echo "============================================================"
sudo systemctl enable --now iptables
sudo systemctl enable --now ufw
sudo ufw default deny
sudo ufw allow from 192.168.1.0/24
sudo ufw allow Deluge
sudo ufw limit ssh

# Configurar boton de log out gnome
echo "============================================================"
echo "[Script] Configurando fish como shell por defecto (cerrar sesión para ver efecto)"
echo "============================================================"
chsh -s /usr/bin/fish

# Configurar boton de log out gnome
echo "============================================================"
echo "[Script] Configurando logout de gnome"
echo "============================================================"
gsettings set org.gnome.shell always-show-log-out true

echo "============================================================"
echo "[Script] Descargando tmux TPM"
echo "============================================================"
# Instalar tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "============================================================"
echo "[Script] Configurando NodeJS"
echo "============================================================"
# Instalar node y pnpm
fnm install 24
fnm use 24
npm i -g pnpm

echo "============================================================"
echo "[Script] Configurando Rust"
echo "============================================================"
# Instalar y configurar rust
rustup default stable

echo "============================================================"
echo "[Script] Habilitando tlp"
echo "============================================================"
sudo systemctl enable --now tlp

echo "============================================================"
echo "[Script] Habilitando syncthing"
echo "============================================================"
sudo systemctl enable --now syncthing@$USER
