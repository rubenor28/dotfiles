#!/bin/bash

# Instalar paquetes
paru -Syu \
gnome-shell-extension-blur-my-shell \
gnome-shell-extension-hidetopbar-git \
gnome-shell-extension-just-perfection-desktop \
gnome-shell-extension-space-bar-git \
gnome-shell-extension-dash-to-dock \
easyeffects \
ttf-ms-fonts \
ttf-wps-fonts \
wps-office \
alacritty \
firefox \
firefox-ublock-origin \
firefox-noscript \
fish \
eza \
bat \
zoxide \
tmux \
yazi \
git \
git-delta \
base-devel \
htop \
btop \
nvtop \
neovim \
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
docker \
docker-compose \
docker-buildx \
dia-git \
obsidian \
filezilla \
cmake \
ulauncher \
--needed

# Configurar boton de log out gnome
gsettings set org.gnome.shell always-show-log-out true

# Instalar tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
