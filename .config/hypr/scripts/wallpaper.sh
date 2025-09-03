#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Pick a random wallpaper (jpg/png/webp)
RANDOM_WALL=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n1)

# Kill existing hyprpaper (to reload config)
pkill hyprpaper

# Write new hyprpaper config
cat > ~/.config/hypr/hyprpaper.conf <<EOF
preload = $RANDOM_WALL
wallpaper = Virtual-1,$RANDOM_WALL
splash = false
EOF

# Restart hyprpaper
hyprpaper &

# Generate colors with Matugen
matugen image "$RANDOM_WALL" --apply gtk waybar

# Reload waybar (so new colors apply)
pkill -SIGUSR2 waybar