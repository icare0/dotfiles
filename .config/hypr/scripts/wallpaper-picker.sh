#!/bin/bash
if pgrep -f "quickshell -c hyprquickpaper" >/dev/null; then
    pkill -f "quickshell -c hyprquickpaper"
else
    quickshell -c hyprquickpaper
fi
