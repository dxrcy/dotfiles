local root = require("src")
local sw = root.sw

-- Windows

hl.bind(root.mod .. " + Q", hl.dsp.window.close())

hl.bind(root.mod .. " + space", function()
    -- Hack to stop windows becoming massive after enabling float
    hl.dispatch(hl.dsp.window.float { action = "toggle" })
    hl.dispatch(hl.dsp.window.resize { x = 1200, y = 800 })
end)
hl.bind(root.mod .. " + F", hl.dsp.window.fullscreen())

-- TODO: Resize in master layout

hl.bind(root.mod .. " + CTRL + H", hl.dsp.focus { monitor = 0 })
hl.bind(root.mod .. " + CTRL + L", hl.dsp.focus { monitor = 1 })

hl.bind(root.mod .. " + P", hl.dsp.window.pin())

hl.bind(root.mod .. " + L", hl.dsp.focus { direction = "right" })
hl.bind(root.mod .. " + H", hl.dsp.focus { direction = "left" })
hl.bind(root.mod .. " + K", hl.dsp.focus { direction = "up" })
hl.bind(root.mod .. " + J", hl.dsp.focus { direction = "down" })

hl.bind(root.mod .. " + SHIFT + L", hl.dsp.window.move { direction = "right" })
hl.bind(root.mod .. " + SHIFT + H", hl.dsp.window.move { direction = "left" })
hl.bind(root.mod .. " + SHIFT + K", hl.dsp.window.move { direction = "up" })
hl.bind(root.mod .. " + SHIFT + J", hl.dsp.window.move { direction = "down" })

-- Workspaces

hl.bind(root.mod .. " + tab", hl.dsp.focus { workspace = "previous" })

for i = 1, 10 do
    local key = i % 10
    hl.bind(root.mod .. " + " .. key, hl.dsp.focus { workspace = i })
    hl.bind(root.mod .. " + SHIFT + " .. key, hl.dsp.window.move { workspace = i })
end

-- Special workspaces

hl.bind(root.mod .. " + grave", sw.toggle_recent())

hl.bind(root.mod .. " + F2", sw.toggle("mail"))
hl.bind(root.mod .. " + F3", sw.toggle("music"))
hl.bind(root.mod .. " + F4", sw.toggle("social"))
hl.bind(root.mod .. " + CTRL + W", sw.toggle("vpn"))

hl.bind(root.mod .. " + SHIFT + F2", hl.dsp.window.move { workspace = "special:mail" })
hl.bind(root.mod .. " + SHIFT + F3", hl.dsp.window.move { workspace = "special:music" })
hl.bind(root.mod .. " + SHIFT + F4", hl.dsp.window.move { workspace = "special:social" })
hl.bind(root.mod .. " + CTRL + SHIFT + W", hl.dsp.window.move { workspace = "special:vpn" })

-- Applications

hl.bind(root.mod .. " + Return", hl.dsp.exec_cmd(root.terminal .. " zellij"))
hl.bind(root.mod .. " + ALT + Return",
    hl.dsp.exec_cmd(root.terminal .. " sh -c 'zellij attach $(zellij ls --short | tail -n1)'"))
hl.bind(root.mod .. " + CTRL + Return",
    hl.dsp.exec_cmd(root.terminal .. " sh -c 'printf \"\\033[1m(no multiplexer)\\n\" && " .. root.shell .. "'"))

hl.bind(root.mod .. " + O", hl.dsp.exec_cmd(root.terminal .. " sh -c 'cd ~/docs/notes && nvim $(notename)'"))

-- Popups

hl.bind(root.mod .. " + D", hl.dsp.exec_cmd('$(terminal-popup fzf-menu "$XDG_DATA_HOME/applications-minimal/")'))
hl.bind(root.mod .. " + SHIFT + D",
    hl.dsp.exec_cmd('$(terminal-popup fzf-menu "/usr/share/applications/ $XDG_DATA_HOME/applications/")'))
hl.bind(root.mod .. " + CTRL + D", hl.dsp.exec_cmd('rofi -show drun'))

hl.bind(root.mod .. " + escape", hl.dsp.exec_cmd('fzf-powermenu'))

hl.bind(root.mod .. " + period", hl.dsp.exec_cmd('wl-copy $(terminal-popup fzf-emoji)'))

hl.bind(root.mod .. " + V", hl.dsp.exec_cmd('foot --app-id=popup-clipse -- clipse'))

hl.bind(root.mod .. " + M", hl.dsp.exec_cmd('mount-gui --notify'))

-- Misc

hl.bind("print", hl.dsp.exec_cmd('flameshot gui'))
hl.bind("SHIFT + print", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))

hl.bind(root.mod .. " + B", hl.dsp.exec_cmd('bt connect'))
hl.bind(root.mod .. " + SHIFT + B", hl.dsp.exec_cmd('bt disconnect'))

hl.bind(root.mod .. " + S", hl.dsp.exec_cmd('player-info notify'))
hl.bind(root.mod .. " + SHIFT + S",
    hl.dsp.exec_cmd('dunstify -t 2000 --replace 8428 "$(date \'+%T\')" "$(date +\'%A %-d %B\\n%FT%T%z\')"'))
hl.bind(root.mod .. " + CTRL + N", hl.dsp.exec_cmd('dunstctl close-all'))

hl.bind(root.mod .. " + U", hl.dsp.exec_cmd(root.scripts .. "/hypridle-toggle.sh"))

hl.bind(root.mod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(root.mod .. " + mouse:273", hl.dsp.window.resize())

hl.bind("XF86PowerOff", hl.dsp.exec_cmd("hyprlock"))

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("volume-brightness.nu mute toggle"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("volume-brightness.nu volume down"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("volume-brightness.nu volume up"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("volume-brightness.nu microphones toggle"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("volume-brightness.nu brightness down"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("volume-brightness.nu brightness up"))

hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))

hl.bind("CTRL + backslash", hl.dsp.exec_cmd("playerctl -p " .. root.player .. " play-pause"))
hl.bind("CTRL + SHIFT + backslash", hl.dsp.exec_cmd("playerctl --all-config.config.player pause"))
hl.bind("CTRL + SHIFT + bracketleft", hl.dsp.exec_cmd("playerctl -p " .. root.player .. " previous"))
hl.bind("CTRL + SHIFT + bracketright", hl.dsp.exec_cmd("playerctl -p " .. root.player .. " next"))
