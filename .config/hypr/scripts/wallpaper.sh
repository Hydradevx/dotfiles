#!/bin/bash

# === CONFIG ===
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

cd "$WALLPAPER_DIR" || exit 1

# === handle spaces name
IFS=$'\n'

# === ICON-PREVIEW SELECTION WITH ROFI, SORTED BY NEWEST ===
SELECTED_WALL=$(for a in $(ls -t *.jpg *.png *.gif *.jpeg 2>/dev/null); do echo -en "$a\0icon\x1f$a\n"; done | rofi -dmenu -p "")
[ -z "$SELECTED_WALL" ] && exit 1
SELECTED_PATH="$WALLPAPER_DIR/$SELECTED_WALL"

# === SET WALLPAPER ===
matugen image "$SELECTED_PATH"

notify-send "Wallpaper changed to $SELECTED_WALL"

# === CREATE SYMLINK ===
mkdir -p "$(dirname "$SYMLINK_PATH")"
ln -sf "$SELECTED_PATH" "$SYMLINK_PATH"