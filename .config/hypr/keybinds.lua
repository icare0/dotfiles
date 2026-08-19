-- ~/.config/hypr/keybinds.lua
-- Migrated from keybinds.conf
-- Docs: https://wiki.hypr.land/Configuring/Basics/Binds/
--       https://wiki.hypr.land/Configuring/Basics/Dispatchers/

local home = os.getenv("HOME")

-- Launchers
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(menu)) -- Spotlight macOS style
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/nightshift.sh"))

-- Emoji Picker (Super + . and Super + ;)
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/emoji-picker.sh"))
hl.bind(mainMod .. " + semicolon", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/emoji-picker.sh"))


-- Scratchpad Terminal (Super + grave `)
hl.bind(mainMod .. " + grave", hl.dsp.focus({ workspace = "special:scratchpad" }))
hl.bind(mainMod .. " + SHIFT + grave", hl.dsp.window.move({ workspace = "special:scratchpad" }))

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind("SUPER + Tab", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("wlogout -b 5 -c 0 -r 0 -L 200 -R 200 -T 420 -B 420"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("bash -c 'pgrep -x quickshell >/dev/null && pkill quickshell || quickshell -c hyprquickpaper'"))


hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = 0 }))

-- Window Groups (Tabbed Windows)
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("hyprctl dispatch togglegroup"))
hl.bind(mainMod .. " + ALT + H", hl.dsp.exec_cmd("hyprctl dispatch changegroupactive b"))
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("hyprctl dispatch changegroupactive f"))
hl.bind(mainMod .. " + ALT + G", hl.dsp.exec_cmd("hyprctl dispatch lockactivegroup toggle"))

hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/opacity.sh"))

-- Cheatsheet / Help Menu (Super + / and Super + F1 and Super + comma)
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/cheatsheet.sh"))
hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/cheatsheet.sh"))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/cheatsheet.sh"))


-- Toggle waybar
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("sh -c 'pgrep -x waybar >/dev/null && pkill waybar || nohup waybar >/dev/null 2>&1 &'"))

-- Screenshots (file + clipboard simultaneously)
hl.bind(mainMod .. " + Delete", hl.dsp.exec_cmd("bash -c 'grim - | tee " .. home .. "/Pictures/$(date +%s).png | wl-copy'"))
hl.bind("Print", hl.dsp.exec_cmd('bash -c \'geom="$(slurp)"; [ -n "$geom" ] && grim -g "$geom" - | tee ' .. home .. '/Pictures/$(date +%s).png | wl-copy\''))



-- Clipboard
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(
    "cliphist list | rofi -dmenu -p '' | cliphist decode | wl-copy"
))

-- Keyboard layout
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("hyprctl switchxkblayout current next"))

-- Toggle window Center and rezise (Super + Shift + Space or Super + Alt + Space)
hl.bind(mainMod .. " + SHIFT + Space", function()

    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))

    local w = hl.get_active_window()
    if w ~= nil and w.floating then
        local mon = hl.get_active_monitor()
        if mon ~= nil then
            local target_w = math.floor(mon.width * 0.7)
            local target_h = math.floor(mon.height * 0.7)

            -- absolute resize (relative = false), not a delta
            hl.dispatch(hl.dsp.window.resize({ x = target_w, y = target_h, relative = false }))

            local mon_x = mon.x or 0
            local mon_y = mon.y or 0
            local target_x = mon_x + math.floor((mon.width - target_w) / 2)
            local target_y = mon_y + math.floor((mon.height - target_h) / 2)

            -- absolute move to the centered position
            hl.dispatch(hl.dsp.window.move({ x = target_x, y = target_y, relative = false }))
        end
    end
end)

-- Mouse move/resize (confirmed pattern from the official example config)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- VERIFY: exit dispatcher. Docs explicitly say to double check the exit
-- dispatcher call when moving to Lua.
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())

-- Focus (H/J/K/L = left/down/up/right, vim-style, matching your original)
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- VERIFY: move active window within layout (old `movewindow` dispatcher).
-- Confirmed pattern is hl.dsp.window.move({ workspace = N }) for sending to a
-- workspace (used below) - the direction-swap variant isn't shown in the
-- official example, so double check this fires like the old movewindow did.
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- VERIFY: resize active window by pixel delta (old `resizeactive`, repeating
-- while held via `binde`). Param names guessed as x/y - confirm with hyprctl eval.
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -40, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 40, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -40 }), { repeating = true })
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 40 }), { repeating = true })

-- Workspaces 1-10
-- Uses keycodes 10-19 (&, é, ", ', (, -, è, _, ç, à) so switching works
-- natively on French AZERTY without needing Shift!
for i = 1, 10 do
    local keycode = 9 + i -- keycode 10 = '1/&', keycode 19 = '0/à'
    local num = i % 10

    -- AZERTY keycode binds
    hl.bind(mainMod .. " + code:" .. keycode, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + code:" .. keycode, hl.dsp.window.move({ workspace = i }))

    -- Fallback standard number binds
    hl.bind(mainMod .. " + " .. num, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. num, hl.dsp.window.move({ workspace = i }))
end


-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Brightness keys
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { locked = true, repeating = true })

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

