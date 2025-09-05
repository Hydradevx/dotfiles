#!/bin/bash

COLORS_FILE="$HOME/.cache/matugen/colors.json"
STARSHIP_CONFIG="$HOME/.config/starship.toml"

if [ ! -f "$COLORS_FILE" ]; then
    echo "Colors file not found! Run matugen first."
    exit 1
fi

# Extract colors from matugen output
PRIMARY=$(jq -r '.colors.primary.hex' "$COLORS_FILE")
SECONDARY=$(jq -r '.colors.secondary.hex' "$COLORS_FILE")
SURFACE=$(jq -r '.colors.surface.hex' "$COLORS_FILE")
ON_SURFACE=$(jq -r '.colors.on_surface.hex' "$COLORS_FILE")

# Backup original config
cp "$STARSHIP_CONFIG" "$STARSHIP_CONFIG.backup"

# Update starship config with new colors
sed -i "s/#b7c4ff/$PRIMARY/g" "$STARSHIP_CONFIG"
sed -i "s/#c2c5dd/$SECONDARY/g" "$STARSHIP_CONFIG"
sed -i "s/#dce1ff/$ON_SURFACE/g" "$STARSHIP_CONFIG"
sed -i "s/#ffb4ab/#ffb4ab/g" "$STARSHIP_CONFIG"  # Keep error color consistent

echo "Starship colors updated to match current theme!"