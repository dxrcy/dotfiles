--------------------------------------------------------------------------------
--                     * Blazingly fast Hyprland config *                     --
--------------------------------------------------------------------------------

-- TODO: Split into files
-- TODO: Add comments
-- TODO: Esperanto keyboard equivalent binds
-- TODO: Call scripts directly from lua
-- TODO: Change initial workspace to 2

local sw = require("scripts.sw")

local fancy = true
local weird = true

local mod = "SUPER"
local monitor1 = "eDP-1"

local terminal = "kitty"
local shell = "zsh"
local browser = "$BROWSER"
local player = "spotify"

local scripts = "~/.config/hypr/scripts/"

--------------------------------------------------------------------------------
-- Monitors

hl.monitor { output = "", mode = "preferred", position = "auto", scale = "auto" }
hl.monitor { output = monitor1, mode = "preferred", position = "auto", scale = "1.6" }

--------------------------------------------------------------------------------
-- Autostart

-- PERF: Maybe add some sleeps between exec_cmd calls ?
hl.on("hyprland.start", function()
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("dunst")
    hl.exec_cmd("clipse -listen")

    hl.exec_cmd("killall hypridle; hypridle")

    -- FIXME: This crashes hyprland on start
    -- hl.exec_cmd("sleep 1; hyprpm reload")

    hl.exec_cmd("wpaperd")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("eww daemon & eww open bar")
    hl.exec_cmd("wvkbd-mobintl --hidden -L 250")

    hl.exec_cmd("sleep 1; bt mute-if-disconnected")
    hl.exec_cmd("sleep 1; volume-brightness.nu microphones disable")

    hl.exec_cmd(browser, { workspace = "1 silent" })

    hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland \
        & sleep 2 & /usr/lib/xdg-desktop-portal")

    hl.dispatch(hl.dsp.focus { workspace = 2 })

    sw.autostart_programs()
end)

--------------------------------------------------------------------------------
-- Variables

hl.config {
    general = {
        border_size = 1,
        gaps_in = 2,
        gaps_out = 0,

        col = {
            inactive_border = 0xff342d01,
            active_border = 0xff9b8921,
        },

        layout = "master",
        no_focus_fallback = true,

        resize_on_border = true,
        hover_icon_on_border = true,

        allow_tearing = false,
    },

    master = {
        mfact = 0.6,
        new_status = "master",
    },

    decoration = {
        rounding = 4,

        blur = {
            enabled = fancy,
        },
        shadow = {
            enabled = fancy,
        },
    },

    animations = {
        enabled = fancy,
    },

    input = {
        sensitivity = 0.1,
        float_switch_override_focus = 0,

        touchpad = {
            disable_while_typing = false,
            natural_scroll = true,
            drag_lock = true,
            flip_x = weird,
            flip_y = weird,
        },
    },

    misc = {
        disable_hyprland_logo = true,

        enable_swallow = true,
        -- TODO: Specify terminal class,
        swallow_regex = "^.*$",

        on_focus_under_fullscreen = 2,
    },

    binds = {
        -- More intuitive when switching to previous workspace
        allow_workspace_cycles = true,

        hide_special_on_workspace_change = true,
    },

    cursor = {
        inactive_timeout = 1,
    },

    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },

    debug = {
        disable_logs = false,
    },
}

--------------------------------------------------------------------------------
-- Animations

hl.curve("rubber", { type = "spring", mass = 0.6, stiffness = 200, dampening = 20 })
hl.animation { leaf = "global", enabled = true, speed = 1, spring = "rubber" }

--------------------------------------------------------------------------------
-- Keybinds - Windows

hl.bind(mod .. " + Q", hl.dsp.window.close())

hl.bind(mod .. " + space", function()
    -- Hack to stop windows becoming massive after enabling float
    hl.dispatch(hl.dsp.window.float { action = "toggle" })
    hl.dispatch(hl.dsp.window.resize { x = 1200, y = 800 })
end)
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())

-- TODO: Resize in master layout

hl.bind(mod .. " + CTRL + H", hl.dsp.focus { monitor = 0 })
hl.bind(mod .. " + CTRL + L", hl.dsp.focus { monitor = 1 })

hl.bind(mod .. " + P", hl.dsp.window.pin())

hl.bind(mod .. " + L", hl.dsp.focus { direction = "right" })
hl.bind(mod .. " + H", hl.dsp.focus { direction = "left" })
hl.bind(mod .. " + K", hl.dsp.focus { direction = "up" })
hl.bind(mod .. " + J", hl.dsp.focus { direction = "down" })

hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move { direction = "right" })
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move { direction = "left" })
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move { direction = "up" })
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move { direction = "down" })

--------------------------------------------------------------------------------
-- Keybinds - Workspaces

hl.bind(mod .. " + tab", hl.dsp.focus { workspace = "previous" })

for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key, hl.dsp.focus { workspace = i })
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move { workspace = i })
end

--------------------------------------------------------------------------------
-- Keybinds - Special workspaces

hl.bind(mod .. " + grave", sw.toggle_recent())

hl.bind(mod .. " + F2", sw.toggle("mail"))
hl.bind(mod .. " + F3", sw.toggle("music"))
hl.bind(mod .. " + F4", sw.toggle("social"))
hl.bind(mod .. " + CTRL + W", sw.toggle("vpn"))

hl.bind(mod .. " + SHIFT + F2", hl.dsp.window.move { workspace = "special:mail" })
hl.bind(mod .. " + SHIFT + F3", hl.dsp.window.move { workspace = "special:music" })
hl.bind(mod .. " + SHIFT + F4", hl.dsp.window.move { workspace = "special:social" })
hl.bind(mod .. " + CTRL + SHIFT + W", hl.dsp.window.move { workspace = "special:vpn" })

--------------------------------------------------------------------------------
-- Keybinds - Applications

hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal .. " zellij"))
hl.bind(mod .. " + ALT + Return", hl.dsp.exec_cmd(terminal .. " sh -c 'zellij attach $(zellij ls --short | tail -n1)'"))
hl.bind(mod .. " + CTRL + Return",
    hl.dsp.exec_cmd(terminal .. " sh -c 'printf \"\\033[1m(no multiplexer)\\n\" && " .. shell .. "'"))

hl.bind(mod .. " + O", hl.dsp.exec_cmd(terminal .. " sh -c 'cd ~/docs/notes && nvim $(notename)'"))

--------------------------------------------------------------------------------
-- Keybinds - Popups

hl.bind(mod .. " + D", hl.dsp.exec_cmd('$(terminal-popup fzf-menu "$XDG_DATA_HOME/applications-minimal/")'))
hl.bind(mod .. " + SHIFT + D",
    hl.dsp.exec_cmd('$(terminal-popup fzf-menu "/usr/share/applications/ $XDG_DATA_HOME/applications/")'))
hl.bind(mod .. " + CTRL + D", hl.dsp.exec_cmd('rofi -show drun'))

hl.bind(mod .. " + escape", hl.dsp.exec_cmd('fzf-powermenu'))

hl.bind(mod .. " + period", hl.dsp.exec_cmd('wl-copy $(terminal-popup fzf-emoji)'))

hl.bind(mod .. " + V", hl.dsp.exec_cmd('foot --app-id=popup-clipse -- clipse'))

hl.bind(mod .. " + M", hl.dsp.exec_cmd('mount-gui --notify'))

--------------------------------------------------------------------------------
-- Keybinds - Misc

hl.bind("print", hl.dsp.exec_cmd('flameshot gui'))
hl.bind("SHIFT + print", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))

hl.bind(mod .. " + B", hl.dsp.exec_cmd('bt connect'))
hl.bind(mod .. " + SHIFT + B", hl.dsp.exec_cmd('bt disconnect'))

hl.bind(mod .. " + S", hl.dsp.exec_cmd('player-info notify'))
hl.bind(mod .. " + SHIFT + S",
    hl.dsp.exec_cmd('dunstify -t 2000 --replace 8428 "$(date \'+%T\')" "$(date +\'%A %-d %B\\n%FT%T%z\')"'))
hl.bind(mod .. " + CTRL + N", hl.dsp.exec_cmd('dunstctl close-all'))

hl.bind(mod .. " + U", hl.dsp.exec_cmd(scripts .. "/hypridle-toggle.sh"))

-- TODO: Mouse dragging

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

hl.bind("CTRL + backslash", hl.dsp.exec_cmd("playerctl -p " .. player .. "play-pause"))
hl.bind("CTRL + SHIFT + backslash", hl.dsp.exec_cmd("playerctl --all-players pause"))
hl.bind("CTRL + SHIFT + bracketleft", hl.dsp.exec_cmd("playerctl -p " .. player .. "previous"))
hl.bind("CTRL + SHIFT + bracketright", hl.dsp.exec_cmd("playerctl -p " .. player .. "next"))

--------------------------------------------------------------------------------
-- Keybinds - Plugins

-- TODO:

---------------------------------------------------------------------------------
-- Window rules

-- TODO:

hl.window_rule {
    name = "popup",
    match = { class = "popup" },
    float = true,
    center = true,
    size = { 400, 400 },
    stay_focused = true,
}

hl.window_rule {
    name = "popup-clipse",
    match = { class = "popup-clipse" },
    float = true,
    center = true,
    size = { 622, 652 },
    stay_focused = true,
}

hl.window_rule {
    name = "flameshot",
    match = { class = "flameshot" },
    float = true,
    pin = true,
    size = { 0, 0 },
    monitor = monitor1,
    stay_focused = true,
    border_size = 0,
}

hl.window_rule {
    name = "windscribe",
    match = { class = "Windscribe" },
    float = true,
    center = true,
    size = { 300, 300 },
}

hl.window_rule {
    name = "firefox-pip",
    match = { class = "Picture-in-Picture" },
    float = true,
    move = { "(monitor_w-window_w-10)", 10 },
    size = { 420, 240 },
}

hl.window_rule {
    name = "minecraft",
    match = { class = "Minecraft\\*.*" },
    tile = true,
}

hl.window_rule {
    name = "ferdium",
    match = { class = "Ferdium" },
    fullscreen_state = 0,
}

-- TODO: Move to sw.lua
hl.window_rule {
    name = "special:mail",
    match = { class = "Mailspring" },
    workspace = "special:mail",
}
hl.window_rule {
    name = "special:spotify",
    match = { class = "Spotify" },
    workspace = "special:music",
}
hl.window_rule {
    name = "special:social",
    match = { class = "Ferdium" },
    workspace = "special:social",
}
hl.window_rule {
    name = "special:vpn",
    match = { class = "Windscribe" },
    workspace = "special:vpn",
}
