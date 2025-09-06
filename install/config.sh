#!/bin/bash

# -- Configuration --
export LOG_FILE="$HOME/rice_install.log"
export DOTFILES_REPO="https://github.com/Hydradevx/dotfiles.git"
export DOTFILES_DIR="$HOME/dotfiles"
export BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Package lists
export HYPR_DEPS=(
    hyprland
    xdg-desktop-portal-hyprland
    waybar
    rofi
    kitty
    swww
    swaync
    wlogout
    hyprlock
    sddm
    neofetch
    starship
    matugen
    qt5ct
)

export RICE_DEPS=(
    arc-gtk-theme
    papirus-icon-theme
    ttf-jetbrains-mono
    ttf-maple
    ttf-nerd-fonts-symbols
    ttf-font-awesome
    noto-fonts
    noto-fonts-emoji
    stow
)

export AUR_DEPS=(
    # Add any AUR-specific packages here if needed
)

# Colors for output
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export NC='\033[0m' # No Color