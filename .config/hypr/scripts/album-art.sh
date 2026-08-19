#!/usr/bin/env bash

COVER_PATH="/tmp/hyprlock_cover.png"
CURRENT_URL_FILE="/tmp/hyprlock_last_url.txt"

arturl=$(playerctl metadata mpris:artUrl 2>/dev/null)

if [[ -n "$arturl" ]]; then
    last_url=""
    [[ -f "$CURRENT_URL_FILE" ]] && last_url=$(cat "$CURRENT_URL_FILE")

    if [[ "$arturl" != "$last_url" || ! -f "$COVER_PATH" ]]; then
        echo "$arturl" > "$CURRENT_URL_FILE"
        if [[ "$arturl" =~ ^file:// ]]; then
            cp "${arturl#file://}" "$COVER_PATH"
        elif [[ "$arturl" =~ ^https?:// ]]; then
            curl -s "$arturl" -o "$COVER_PATH"
        fi
    fi
    echo "$COVER_PATH"
else
    rm -f "$COVER_PATH" "$CURRENT_URL_FILE"
    echo ""
fi
