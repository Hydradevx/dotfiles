#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"

# Initialize swww if not running
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon
    sleep 1
fi

if command -v swaync >/dev/null 2>&1; then
    echo "Reloading SwayNC..."
    swaync-client -rs
fi

RANDOM_WALL=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | shuf -n1)

if [ -n "$RANDOM_WALL" ]; then
    # Generate colors with Matugen
    matugen image "$RANDOM_WALL"

    SELECTED_PATH="$WALLPAPER_DIR/$RANDOM_WALL"

    mkdir -p "$(dirname "$SYMLINK_PATH")"
    ln -sf "$SELECTED_PATH" "$SYMLINK_PATH"
    
    echo "Wallpaper set: $RANDOM_WALL"
else
    echo "No wallpapers found in $WALLPAPER_DIR"
fi