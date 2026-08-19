#!/usr/bin/env bash

# Toggle battery power profiles (power-saver -> balanced -> performance)
if ! command -v powerprofilesctl >/dev/null 2>&1; then
    notify-send "Batterie" "power-profiles-daemon n'est pas installé." -i battery
    exit 0
fi

current=$(powerprofilesctl get)

case "$current" in
    "power-saver")
        powerprofilesctl set balanced
        notify-send -t 2000 -i battery-good "Profil d'énergie : Équilibré ⚖️" "Performances et autonomie optimales"
        ;;
    "balanced")
        powerprofilesctl set performance
        notify-send -t 2000 -i battery-full-charging "Profil d'énergie : Performance 🚀" "Puissance maximale du processeur"
        ;;
    "performance"|*)
        powerprofilesctl set power-saver
        notify-send -t 2000 -i battery-low "Profil d'énergie : Économie 🔋" "Autonomie maximale pour la batterie"
        ;;
esac
