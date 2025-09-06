#!/bin/bash

source config.sh

# Logging functions
log_info() {
    echo -e "${BLUE}==>${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}==> SUCCESS:${NC} $1" | tee -a "$LOG_FILE"
}

log_warn() {
    echo -e "${YELLOW}==> WARNING:${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}==> ERROR:${NC} $1" | tee -a "$LOG_FILE"
    exit 1
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Run command with error checking
run_cmd() {
    local cmd="$*"
    log_info "Running: $cmd"
    if ! eval "$cmd" 2>> "$LOG_FILE"; then
        log_error "Command failed: $cmd\nCheck $LOG_FILE for details"
    fi
}

# Backup existing file/directory
backup_if_exists() {
    local target="$1"
    if [[ -e "$target" || -L "$target" ]]; then
        log_info "Backing up $target to $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/" 2>/dev/null || sudo mv "$target" "$BACKUP_DIR/"
    fi
}

# Check if running as root
check_not_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root"
    fi
}

# Check if running on Arch Linux
check_arch_linux() {
    if ! command_exists pacman; then
        log_error "This script is designed for Arch Linux only"
    fi
}