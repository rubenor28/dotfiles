#!/bin/bash
sudo pacman -Rns power-profiles-daemon

# Instalar paquetes
paru -Syu \
gnome-shell-extension-blur-my-shell \
gnome-shell-extension-hidetopbar-git \
gnome-shell-extension-just-perfection-desktop \
gnome-shell-extension-space-bar-git \
gnome-shell-extension-dash-to-dock \
easyeffects \
audacious \
ttf-cascadia-code-nerd \
ttf-ms-fonts \
ttf-wps-fonts \
wps-office \
alacritty \
firefox \
firefox-ublock-origin \
fish \
eza \
bat \
zoxide \
tmux \
yazi \
fzf \
snapper \
snap-pac \
cachyos-snapper-support \
btrfs-assistant \
tlp \
tlp-rdw \
tlpui \
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
--needed

# Configurar boton de log out gnome
gsettings set org.gnome.shell always-show-log-out true

# Instalar tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Instalar node y pnpm
fnm install 24
fnm use 24
npm i -g pnpm

# Instalar y configurar rust
rustup default stable
