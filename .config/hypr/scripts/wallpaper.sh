#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Initialize swww if not running
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon
    sleep 1
fi

# Pick a random wallpaper (jpg/png/webp)
RANDOM_WALL=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n1)

if [ -n "$RANDOM_WALL" ]; then
    # Set wallpaper with swww
    swww img "$RANDOM_WALL" --transition-type grow --transition-pos 0.854,0.977 --transition-step 255 --transition-fps 60
    
    # Generate colors with Matugen
    matugen image "$RANDOM_WALL" --apply gtk waybar
    
    # Reload waybar (so new colors apply)
    pkill -SIGUSR2 waybar
    
    echo "Wallpaper set: $RANDOM_WALL"
else
    echo "No wallpapers found in $WALLPAPER_DIR"
fi