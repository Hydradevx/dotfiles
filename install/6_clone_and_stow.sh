#!/bin/bash

source utilities.sh

log_info "Setting up dotfiles..."

# Backup and clone dotfiles
if [[ -d "$DOTFILES_DIR" ]]; then
    log_info "Dotfiles directory exists, pulling latest changes..."
    run_cmd "cd $DOTFILES_DIR && git pull --rebase"
else
    run_cmd "git clone $DOTFILES_REPO $DOTFILES_DIR"
fi

# Navigate to dotfiles directory
cd "$DOTFILES_DIR" || log_error "Failed to enter dotfiles directory"

# Stow all configurations (force overwrite)
for dir in */; do
    dir=${dir%/}
    if [[ -d "$dir" ]]; then
        log_info "Stowing $dir..."
        backup_if_exists "$HOME/.$dir"
        backup_if_exists "$HOME/.config/$dir"
        
        # Use stow with --adopt to handle conflicts and --override to force
        run_cmd "stow --target=$HOME --adopt --override=* $dir"
    fi
done

log_success "Dotfiles stowed successfully"