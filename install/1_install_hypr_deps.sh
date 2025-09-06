#!/bin/bash

source utilities.sh

log_info "Installing base Hyprland dependencies..."

# Update system first
run_cmd "sudo pacman -Syu --noconfirm"

# Install Hyprland and related packages
run_cmd "sudo pacman -S --needed --noconfirm ${HYPR_DEPS[*]}"

log_success "Hyprland dependencies installed"