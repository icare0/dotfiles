#!/usr/bin/env bash

# Interactive Wi-Fi menu using nmcli and rofi
notify-send "Wi-Fi" "Recherche des réseaux disponibles..." -i network-wireless -t 1500

# Get list of Wi-Fi networks
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/🔒 /g" | sed "s/^--/🔓 /g" | sed "s/🔒 🔒/🔒/g" | sed "/--/d" | awk '!seen[$0]++')

if [[ -z "$wifi_list" ]]; then
    notify-send "Wi-Fi" "Aucun réseau Wi-Fi trouvé." -i network-wireless-offline
    exit 0
fi

# Show networks in rofi
chosen_network=$(echo -e "$wifi_list" | rofi -dmenu -i -p "📡 Wi-Fi" -theme-str 'window { width: 420px; height: 400px; }')

# Exit if nothing selected
[[ -z "$chosen_network" ]] && exit 0

# Parse SSID
ssid=$(echo "$chosen_network" | sed 's/^[^ ]* *//')

# Check if connection already exists
saved_connections=$(nmcli -g NAME connection)
if echo "$saved_connections" | grep -w "$ssid" > /dev/null; then
    nmcli connection up id "$ssid" | grep "successfully" && notify-send "Wi-Fi" "Connecté à $ssid !" -i network-wireless
else
    if [[ "$chosen_network" =~ "🔒" ]]; then
        wifi_password=$(rofi -dmenu -password -p "🔑 Mot de passe ($ssid)" -theme-str 'window { width: 380px; height: 180px; }')
        [[ -z "$wifi_password" ]] && exit 0
        nmcli device wifi connect "$ssid" password "$wifi_password" | grep "successfully" && notify-send "Wi-Fi" "Connecté à $ssid !" -i network-wireless || notify-send "Wi-Fi" "Erreur de connexion" -i dialog-error
    else
        nmcli device wifi connect "$ssid" | grep "successfully" && notify-send "Wi-Fi" "Connecté à $ssid !" -i network-wireless
    fi
fi
