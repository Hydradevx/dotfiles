# Hyprland Rice Installer

A one-command installation script for my Hyprland desktop environment rice. This script automates the installation of all dependencies, configurations, and themes.

## 🚀 Quick Install

**Warning:** This script will overwrite existing configurations. Please back up your important files before proceeding.

### Direct curl to bash 
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Hydradevx/dotfiles/install/main.sh)
```

## 📋 Prerequisites

- **Arch Linux** or an Arch-based distribution (EndeavourOS, Manjaro, etc.)
- **Internet connection** (the script downloads packages and dependencies)
- **sudo privileges** (for package installation)

## ⚠️ Important Notes

- **Backup your data**: This script will overwrite existing configuration files in:
  - `~/.config/`
  - `~/.zshrc`
  - And other dotfiles locations

- **System requirements**:
  - At least 2GB of free disk space
  - Stable internet connection
  - Fresh Arch installation recommended

## 🔧 What This Installs

### Core Components
- **Hyprland** (Wayland compositor)
- **Required dependencies** (xdg-desktop-portal-hyprland, waybar, etc.)

### Applications & Tools
- **Kitty** (terminal emulator)
- **Rofi** (application launcher)
- **Waybar** (status bar)
- **Swww** (wallpaper utility)
- **SwayNC** (notification center)
- **Wlogout** (logout menu)

### Theming & Appearance
- **Zsh + Oh My Zsh** (shell environment)
- **Nerd Fonts** (JetBrains Mono, Maple Mono, etc.)
- **GTK Themes** (Arc Dark, Papirus icons)
- **Starship** (shell prompt)
- **Neofetch** (system information)

## 📊 Installation Process

The script will:

1. **Update** your system
2. **Install** Hyprland and core dependencies
3. **Set up** Zsh with Oh My Zsh
4. **Install** Yay (AUR helper)
5. **Add** Nerd Fonts and themes
6. **Install** additional rice dependencies
7. **Clone** and **stow** dotfiles from this repository
8. **Backup** any existing configurations

## ❓ Troubleshooting

### Common Issues

1. **"Command not found: curl"**
   ```bash
   sudo pacman -S curl
   ```

2. **Permission denied errors**
   ```bash
   # Ensure you have sudo privileges
   sudo pacman -S --needed base-devel
   ```

3. **Script stops unexpectedly**
   Check the log file: `~/rice_install.log`

4. **AUR packages fail to install**
   ```bash
   # Update yay and retry
   yay -Syu
   ```

### Manual Recovery

If the script fails, you can:
1. Check the backup directory: `~/dotfiles_backup_YYYYMMDD_HHMMSS/`
2. Restore your original configurations from the backup
3. Review the log file for specific errors: `~/rice_install.log`

## 📝 Post-Installation

After successful installation:

1. **Reboot your system** or **log out**
2. **Select Hyprland** from your display manager (SDDM)
3. **Customize** further by editing files in `~/.config/`

## 🔄 Updating

To update your rice configuration:

```bash
# Navigate to your dotfiles directory
cd ~/dotfiles

# Pull the latest changes
git pull

# Re-run stow to update symlinks
./install.sh
```

## 📄 License

This project is licensed under the MIT License. See the LICENSE file for details.

## 🤝 Contributing

Feel free to fork this repository and adapt the installation script for your own rice!