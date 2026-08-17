#!/bin/bash
# DEPRECATED — this script is no longer called by any keybind.
# The float-toggle logic was migrated to keybinds.lua (Super+Space)
# as an inline Lua function that doesn't require jq.
# Kept here for reference only.

hyprctl dispatch togglefloating

sleep 0.05

floating=$(hyprctl activewindow -j | jq -r '.floating')

if [ "$floating" = "true" ]; then
    hyprctl dispatch resizeactive exact 70% 70%
    hyprctl dispatch centerwindow
fi
