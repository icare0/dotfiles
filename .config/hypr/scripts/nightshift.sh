#!/usr/bin/env bash

# Night shift / blue light filter toggle
if pgrep -x hyprsunset >/dev/null 2>&1; then
    pkill hyprsunset
    notify-send "Mode Nuit : Désactivé ☀️" "Température d'écran normale" -i display-brightness
elif pgrep -x wlsunset >/dev/null 2>&1; then
    pkill wlsunset
    notify-send "Mode Nuit : Désactivé ☀️" "Température d'écran normale" -i display-brightness
else
    if command -v hyprsunset >/dev/null 2>&1; then
        hyprsunset -t 4500 &
        notify-send "Mode Nuit : Activé 🌙" "Filtre anti-lumière bleue (4500K)" -i night-light
    elif command -v wlsunset >/dev/null 2>&1; then
        wlsunset -t 4500 -T 6500 &
        notify-send "Mode Nuit : Activé 🌙" "Filtre anti-lumière bleue (4500K)" -i night-light
    fi
fi
