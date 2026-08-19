## Simple Hyprland Rice

**Full showcase: https://www.youtube.com/watch?v=kYZ5mkGuQEg**

Simple Hyprland setup focused on practical keybinds, productivity, and a smooth workflow easy to customize

Feel free to use as inspiration or as a starting point for building your own setup.

![](x.png)
![](lock.png)
![](z.png)
![](ww.png)

Wallpapers: https://wallhaven.cc/user/43pr

## Features

* **Waybar**
> Workspaces, hardware stats (CPU/GPU/RAM/Temp), network, bluetooth, battery, MPRIS media control, audio with mouse wheel, notifications, and power menu
* **Bluetooth (Blueman)**
> Integrated bluetooth management with tray applet and GUI manager
* **Window Groups (Tabs)**
> Group multiple windows into a single tabbed frame with colored headers (`Super + G`)
* **SwayNC**
> Modern control center with notifications, volume & brightness sliders, DND toggle, and media widget (`Super + N`)
* **Rofi**
> Fuzzy application search (`Super + D`), clipboard history (`Super + V`), and interactive window opacity switcher (`Super + O`)
* **Hyprlock & Hypridle**
> Screen lock with live clock, battery & media controls, and automatic sleep/dim power management
* **Wlogout**
> 5-button power menu (Lock, Suspend, Shutdown, Reboot, Logout)
* **Quickshell (hyprquickpaper)**
> Smooth animated horizontal wallpaper picker (`Super + W`) with Matugen/Pywal theme hooks
* **Kitty Terminal + Starship Prompt**
> Tokyo Night Moon theme with 85% opacity, blur, beam cursor with trail, Nerd fonts, and cross-shell prompt with git and battery indicators
* **Spotify + Spicetify**
> Themed Spotify interface with automated installer integration

### Most used keybinds

> **$mod = Super / Windows key**

| Keybind | Action |
| --- | --- |
| `Super + T` | Open terminal (Kitty) |
| `Super + P` | Open application launcher (Tide Island) |
| `Super + E` | Open file manager (Thunar) |
| `Super + B` | Open browser (Brave / Firefox) |
| `Super + A` | Toggle Workspace Overview (Tide Island) |
| `Super + C` | Toggle Control Center (Tide Island) |
| `Super + M` | Toggle Music Player (Tide Island) |
| `Super + N` | Toggle Notification Center (Tide Island) |
| `Super + \`` | Toggle Scratchpad Terminal |
| `Super + W` | Open wallpaper selector (Quickshell) |
| `Super + O` | Switch opacity dynamically |
| `Super + V` | Open clipboard history |
| `Print` | Area screenshot to file + clipboard |
| `Super + Delete` | Fullscreen screenshot to file + clipboard |
| `Super + Q` | Close active window |
| `Super + F` | Toggle fullscreen |
| `Super + Space` | Toggle floating & center (70% size) |
| `Super + G` | Toggle tabbed window group |
| `Super + Alt + H / L` | Navigate previous / next tab in group |
| `Super + Tab` | Lock screen (Hyprlock) |
| `Super + Esc` | Open logout menu (Wlogout) |

---

### Installed Programs & Tools:

```text
Hyprland
Hyprlock & Hypridle
Waybar
SwayNC
Rofi
Wlogout
Quickshell
Awww (Wallpaper daemon)
Grim & Slurp
Cliphist & Wl-clipboard
PipeWire & WirePlumber
Brightnessctl & Playerctl
Kitty, Fastfetch & Starship Prompt
```

---
## Installation
> **Note:** Some paths and applications are specific to my setup. You may need to modify the configuration files to match your system.

**Clone the repository and run the installer:**

```bash
git clone https://github.com/43PR/dotfiles.git
cd dotfiles
chmod +x install.sh
./install.sh
```

### What it does:

The installer will modify your ~/.config directory. 

Existing configuration files that are being replaced will be backed up automatically.

Install the required Arch Linux packages from packages.txt

Back up existing configuration files before replacing them

Copy the dotfiles into ~/.config

Set the required script permissions

Enable the required user services

After the installation finishes, restart Hyprland or log out and back in.

```bash
hyprctl reload
```

If you encounter any issues, check the relevant configuration files under: ~/.config/

---

* [hyprquickpaper](https://github.com/iamsurjog/hyprquickpaper)
* [samaritan-sddm-theme](https://github.com/omerwk/samaritan-sddm-theme)


