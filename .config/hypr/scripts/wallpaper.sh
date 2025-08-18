#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Make sure swww daemon is running
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 0.5
fi

# Pick a random wallpaper (only jpg/png/webp)
RANDOM_WALL=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n1)

# Set wallpaper with smooth transition & quality options
swww img "$RANDOM_WALL" \
    --transition-type any \
    --transition-fps 60 \
    --transition-duration 2 \
    --resize crop \
    --fill-color "#000000"
    
# Generate colors with pywal
wal -i "$WALLPAPER_DIR/$RANDOM_WALL" -n -q

# Copy generated colors into Waybar
cp ~/.cache/wal/colors-waybar.css ~/.config/waybar/colors.css

# Reload waybar
pkill -SIGUSR2 waybar