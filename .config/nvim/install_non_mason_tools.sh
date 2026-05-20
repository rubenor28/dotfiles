#!/usr/bin/bash
dotnet tool install --global roslyn-language-server --prerelease
sudo pacman -Sy tree-sitter-cli fzf --needed
