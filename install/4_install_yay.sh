#!/bin/bash

source utilities.sh

log_info "Installing Yay AUR helper..."

if command_exists yay; then
    log_info "Yay is already installed"
    return 0
fi

# Install dependencies for building yay
run_cmd "sudo pacman -S --needed --noconfirm base-devel git"

# Clone and install yay
TMP_DIR=$(mktemp -d)
run_cmd "git clone https://aur.archlinux.org/yay.git $TMP_DIR/yay"
cd "$TMP_DIR/yay"
run_cmd "makepkg -si --noconfirm"
cd -
run_cmd "rm -rf $TMP_DIR"

log_success "Yay installed successfully"