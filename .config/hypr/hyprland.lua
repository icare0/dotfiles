-- ~/.config/hypr/hyprland.lua
-- Docs: https://wiki.hypr.land/Configuring/Start/

-- Monitor configuration — edit to match YOUR hardware.
-- This default enables every connected monitor automatically (safe for laptops
-- and single-monitor desktops).
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- Multi-monitor example: uncomment and edit the lines below for a specific setup.
-- hl.monitor({ output = "eDP-1",   disabled = true })                                    -- disable laptop screen
-- hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto", scale = 1 })  -- external monitor only


---- MY PROGRAMS ----

mainMod    = "SUPER"
terminal   = "kitty"
menu       = "rofi -show drun"
fileManager = "thunar"
browser    = "brave-browser"


---- AUTOSTART ----

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")

    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("sleep 1 && awww img " .. os.getenv("HOME") .. "/Pictures/Wallpapers/w4.png")
end)

---- INPUT ----

hl.config({
    input = {
        kb_layout = "fr",
        follow_mouse = 1,
        sensitivity = 0.3,
        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
            disable_while_typing = true,
            clickfinger_behavior = true,
        },
    },
    gestures = {
        workspace_swipe = true,
        workspace_swipe_fingers = 3,
        workspace_swipe_distance = 300,
    },
})


---- LOOK AND FEEL ----

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 6,
        border_size = 2,
        col_active_border = "rgba(7aa2f7ee) rgba(bb9af7ee) 45deg",
        col_inactive_border = "rgba(41486833)",
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 10,
        blur = {
            enabled = true,
            size = 6,
            passes = 2,
            vibrancy = 0.25,
            new_optimizations = true,
        },
        shadow = {
            enabled = true,
            range = 25,
            render_power = 4,
            color = "rgba(00000055)",
            color_inactive = "rgba(00000025)",
        },
        dim_inactive = true,
        dim_strength = 0.12,
        dim_special = 0.3,
    },
    animations = {
        enabled = true,
        animate_manual_resizes = true,
        animate_mouse_windowdragging = true,
    },
})

-- Animation curves
hl.curve("fluid",       { type = "bezier", points = { {0.25, 1.0}, {0.5, 1.0} } })
hl.curve("easeOut",     { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.0} } })
hl.curve("easeOutBack", { type = "bezier", points = { {0.34, 1.3}, {0.64, 1.0} } })
hl.curve("easeOutExpo", { type = "bezier", points = { {0.16, 1.0}, {0.3, 1.0} } })

-- Smooth Animations
hl.animation({ leaf = "windows",          enabled = true, speed = 6, bezier = "fluid",      style = "popin 80%" })
hl.animation({ leaf = "windowsOut",       enabled = true, speed = 5, bezier = "fluid",      style = "popin 80%" })
hl.animation({ leaf = "border",           enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "fade",             enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "workspaces",       enabled = true, speed = 5, bezier = "fluid",      style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "fluid",      style = "scale 85%" })

-- LAYOUT
hl.config({
    dwindle = {
        preserve_split = true,
        special_scale_factor = 0.85,
    },
})
hl.config({
    master = { new_status = "master" },
})

-- GROUPS (Tabbed windows)
hl.config({
    group = {
        col_border_active = "rgba(7aa2f7ee)",
        col_border_inactive = "rgba(41486844)",
        groupbar = {
            enabled = true,
            font_family = "JetBrainsMono Nerd Font",
            font_size = 10,
            text_color = "rgba(ffffffff)",
            col_active = "rgba(7aa2f7cc)",
            col_inactive = "rgba(15161ecc)",
            gradients = true,
        },
    },
})


-- MISC
hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        vrr = 1,
    },
})

---- SPLIT-OUT FILES ----

require("env")
require("keybinds")
require("rules")

