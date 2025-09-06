#!/bin/bash

source utilities.sh

# Main execution function
main() {
    log_info "Starting rice installation..."
    log_info "Log file: $LOG_FILE"
    
    # Initial checks
    check_not_root
    check_arch_linux
    
    # Execute installation steps
    source 1_install_hypr_deps.sh
    source 2_setup_zsh.sh
    source 4_install_yay.sh
    source 5_install_rice_deps.sh
    source 3_install_fonts.sh
    source 6_clone_and_stow.sh
    
    # Final messages
    log_success "Installation complete!"
    log_info "Backups are stored in: $BACKUP_DIR"
    log_info "Installation log: $LOG_FILE"
    log_warn "Please reboot or restart your session for all changes to take effect"
}

# Run main function and handle interrupts
trap 'log_error "Installation interrupted by user"; exit 1' INT
main "$@"