#!/bin/bash

source utilities.sh

log_info "Installing Nerd Fonts..."

# Install fonts from official repos
run_cmd "sudo pacman -S --noconfirm ${FONT_DEPS[*]}"

# Additional font setup
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

# Update font cache
run_cmd "fc-cache -fv"

log_success "Fonts installed and cache updated"