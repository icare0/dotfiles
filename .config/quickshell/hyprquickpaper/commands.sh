#!/usr/bin/env bash

# Set Wallpaper with smooth transition
awww img "$1" -t random --transition-duration 1

# Optional: Dynamic color extraction if matugen or wal is installed
if command -v matugen >/dev/null 2>&1; then
    matugen image "$1" >/dev/null 2>&1 &
elif command -v wal >/dev/null 2>&1; then
    wal -i "$1" -n -q >/dev/null 2>&1 &
fi

