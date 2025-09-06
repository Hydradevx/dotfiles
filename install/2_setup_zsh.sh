#!/bin/bash

source utilities.sh

log_info "Setting up Zsh and Oh My Zsh..."

# Install Zsh if not already installed
if ! command_exists zsh; then
    run_cmd "sudo pacman -S --noconfirm zsh"
fi

# Set Zsh as default shell if not already
if [[ "$SHELL" != "$(which zsh)" ]]; then
    run_cmd "chsh -s $(which zsh)"
    log_success "Zsh set as default shell"
else
    log_info "Zsh is already the default shell"
fi

# Install Oh My Zsh if not present
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    run_cmd 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
    log_success "Oh My Zsh installed"
else
    log_info "Oh My Zsh already installed"
fi

log_success "Zsh setup complete"