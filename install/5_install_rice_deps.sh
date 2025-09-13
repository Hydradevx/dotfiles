#!/bin/bash

source utilities.sh

log_info "Installing rice dependencies..."

# Install GTK themes, icons, and other rice deps
run_cmd "sudo pacman -S --needed --noconfirm ${RICE_DEPS[*]}"

# Install any AUR packages if specified
if [[ ${#AUR_DEPS[@]} -gt 0 ]]; then
    log_info "Installing AUR packages..."
    run_cmd "yay -S --noconfirm ${AUR_DEPS[*]}"
fi

# Additional theming setup
run_cmd "gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Dark'"
run_cmd "gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'"

run_cmd "cd ~ && git clone --depth 1 https://github.com/VandalByte/darkmatter-grub2-theme.git && cd darkmatter-grub2-theme && sudo python3 darkmatter-theme.py --install"

log_success "All rice dependencies installed"