#!/usr/bin/env bash

# Visual Cheatsheet for Hyprland & Keybindings
categories=(
    "🚀 [Super + T]          Terminal Kitty (Fastfetch & Starship)"
    "🔍 [Super + D]          Lanceur d'applications (Rofi)"
    "🌐 [Super + B]          Navigateur Web (Brave / Zen)"
    "📁 [Super + E]          Explorateur de fichiers (Thunar)"
    "🖼️  [Super + W]          Sélecteur de fond d'écran animé"
    "😀 [Super + .]          Sélecteur d'Emojis rapide"
    "--------------------------------------------------------"
    "❌ [Super + Q]          Fermer la fenêtre active"
    "⛶  [Super + F]          Plein écran (Toggle)"
    "🪟 [Super + Espace]     Fenêtre flottante libre (Toggle)"
    "📑 [Super + G]          Grouper des fenêtres en onglets"
    "↔️  [Super + Alt + H/L]  Changer d'onglet dans le groupe"
    "--------------------------------------------------------"
    "🖱️  [Super + Clic G]     Déplacer une fenêtre à la souris"
    "📐 [Super + Clic D]     Redimensionner une fenêtre à la souris"
    "💻 [Super + 1 à 9]      Aller sur le bureau 1, 2, 3..."
    "🖐️ [Glisser 3 doigts]   Glissement fluide entre les bureaux"
    "--------------------------------------------------------"
    "📸 [Impr Écran]         Capture zone -> Presse-papiers + Fichier"
    "📸 [Super + Suppr]      Capture tout l'écran"
    "📋 [Super + V]          Historique du Presse-papiers"
    "🎛️  [Super + N]          Centre de contrôle & Notifications"
    "🪄 [Super + O]          Régler l'opacité / transparence"

    "🛸 [Super + \`]          Terminal tiroir secret (Scratchpad)"
    "🔒 [Super + Tab]        Verrouiller l'écran (Hyprlock + Musique)"
    "⚡ [Super + Échap]      Menu d'extinction (Wlogout)"
)

printf "%s\n" "${categories[@]}" | rofi -dmenu -i -p "⌨️ Raccourcis" -theme-str 'window { width: 540px; height: 560px; } listview { lines: 14; }'
