#!/bin/bash

# prints current Hyprland workspace
hyprctl workspaces | awk '/active/ {print $2}'