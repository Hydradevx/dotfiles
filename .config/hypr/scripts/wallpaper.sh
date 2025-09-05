#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Initialize swww if not running
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon
    sleep 1
fi

RANDOM_WALL=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n1)

if [ -n "$RANDOM_WALL" ]; then
    # Generate colors with Matugen
    matugen image "$RANDOM_WALL"
    
    echo "Wallpaper set: $RANDOM_WALL"
else
    echo "No wallpapers found in $WALLPAPER_DIR"
fi