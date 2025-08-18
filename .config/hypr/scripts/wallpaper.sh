#!/bin/bash
WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Pick a random wallpaper
RANDOM_WALL=$(ls "$WALLPAPER_DIR" | shuf -n1)

# Set it
swww img "$WALLPAPER_DIR/$RANDOM_WALL" --transition-type any --transition-fps 60 --transition-duration 2