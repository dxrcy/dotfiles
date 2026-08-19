local root = require("src")
local sw = require("src.sw")
local autostart = require("src.autostart")
local actions = require("src.actions")
local bind = actions.bind

-- Windows

bind({ root.mod, "SHIFT", "R" }, function() autostart(false) end)

bind({ root.mod, "Q" }, hl.dsp.window.close())

bind({ root.mod, "C" }, actions.toggle_weird)

bind({ root.mod, "SHIFT", "space" }, actions.toggle_float)

bind({ root.mod, "F" }, hl.dsp.window.fullscreen { mode = 1, action = "toggle" })
bind({ root.mod, "SHIFT", "F" }, hl.dsp.window.fullscreen())

local resize_large = 80
local resize_small = 20
bind({ root.mod, "ALT", "H" }, hl.dsp.window.resize { x = -resize_large, y = 0, relative = true })
bind({ root.mod, "ALT", "L" }, hl.dsp.window.resize { x = resize_large, y = 0, relative = true })
bind({ root.mod, "ALT", "K" }, hl.dsp.window.resize { x = 0, y = resize_large, relative = true })
bind({ root.mod, "ALT", "J" }, hl.dsp.window.resize { x = 0, y = -resize_large, relative = true })
bind({ root.mod, "ALT", "SHIFT", "H" }, hl.dsp.window.resize { x = -resize_small, y = 0, relative = true })
bind({ root.mod, "ALT", "SHIFT", "L" }, hl.dsp.window.resize { x = resize_small, y = 0, relative = true })
bind({ root.mod, "ALT", "SHIFT", "K" }, hl.dsp.window.resize { x = 0, y = resize_small, relative = true })
bind({ root.mod, "ALT", "SHIFT", "J" }, hl.dsp.window.resize { x = 0, y = -resize_small, relative = true })

bind({ root.mod, "CTRL", "H" }, hl.dsp.focus { monitor = 0 })
bind({ root.mod, "CTRL", "L" }, hl.dsp.focus { monitor = 1 })

bind({ root.mod, "P" }, hl.dsp.window.pin())

bind({ root.mod, "SHIFT", "P" }, actions.toggle_popup_float)

bind({ root.mod, "L" }, hl.dsp.focus { direction = "right" })
bind({ root.mod, "H" }, hl.dsp.focus { direction = "left" })
bind({ root.mod, "K" }, hl.dsp.focus { workspace = "-1" })
bind({ root.mod, "J" }, hl.dsp.focus { workspace = "+1" })

-- For focusing floating windows
-- TODO: Only toggle between most recent floating window and most recent tiling window
bind({ root.mod, "space" }, hl.dsp.window.cycle_next())

bind({ root.mod, "SHIFT", "L" }, hl.dsp.window.move { direction = "right" })
bind({ root.mod, "SHIFT", "H" }, hl.dsp.window.move { direction = "left" })
bind({ root.mod, "SHIFT", "K" }, hl.dsp.window.move { workspace = "-1" })
bind({ root.mod, "SHIFT", "J" }, hl.dsp.window.move { workspace = "+1" })

bind({ root.mod, "N" }, actions.set_oneshot_swallow)
bind({ root.mod, "SHIFT", "N" }, actions.toggle_swallow)

-- Workspaces

bind({ root.mod, "tab" }, hl.dsp.focus { workspace = "previous" })

for i = 1, 10 do
	local key = tostring(i % 10)
	bind({ root.mod, key }, hl.dsp.focus { workspace = i })
	bind({ root.mod, "SHIFT", key }, hl.dsp.window.move { workspace = i, follow = false })
end

bind({ root.mod, "CTRL", "SHIFT", "K" }, actions.shift_workspace(-1))
bind({ root.mod, "CTRL", "SHIFT", "J" }, actions.shift_workspace(1))

bind({ root.mod, "CTRL", "ALT", "H" }, hl.dsp.workspace.move { monitor = 0 })
bind({ root.mod, "CTRL", "ALT", "L" }, hl.dsp.workspace.move { monitor = 1 })

-- Special workspaces

bind({ root.mod, "grave" }, sw.toggle_recent())

for _, program in ipairs(sw.programs) do
	if program.keybind_toggle then
		bind(program.keybind_toggle, sw.toggle(program.name))
	end
	if program.keybind_move then
		bind(program.keybind_move, sw.move(program.name))
	end
end

-- Applications

bind({ root.mod, "Return" }, actions.open_terminal("new"))
bind({ root.mod, "ALT", "Return" }, actions.open_terminal("reattach"))
bind({ root.mod, "CTRL", "Return" }, actions.open_terminal("no_mux"))

bind({ root.mod, "SHIFT", "O" }, actions.open_notes)

-- Popups

bind({ root.mod, "D" }, actions.open_runner("minimal"))
bind({ root.mod, "SHIFT", "D" }, actions.open_runner("global"))
bind({ root.mod, "CTRL", "D" }, actions.open_runner("fallback"))

bind({ root.mod, "escape" }, hl.dsp.exec_cmd("fzf-powermenu"))

bind({ root.mod, "period" }, hl.dsp.exec_cmd("wl-copy $(terminal-popup fzf-emoji)"))

bind({ root.mod, "V" }, hl.dsp.exec_cmd("foot --app-id=popup-clipse -- clipse"))

bind({ root.mod, "M" }, hl.dsp.exec_cmd("mount-gui --notify"))

-- Misc

bind({ "ALT", "Q" }, actions.switch_kb_layout)

bind({ "print" }, hl.dsp.exec_cmd("flameshot gui"))
bind({ "SHIFT", "print" }, hl.dsp.exec_cmd('pgrep slurp || grim -g "$(slurp -d)" - | wl-copy'))

bind({ root.mod, "B" }, hl.dsp.exec_cmd("bt connect"))
bind({ root.mod, "SHIFT", "B" }, hl.dsp.exec_cmd("bt disconnect"))

bind({ root.mod, "S" }, hl.dsp.exec_cmd("player-info notify"))
bind(
	{ root.mod, "SHIFT", "S" },
	hl.dsp.exec_cmd("dunstify -t 2000 --replace 8428 \"$(date '+%T')\" \"$(date +'%A %-d %B')\"")
)
bind({ root.mod, "CTRL", "N" }, hl.dsp.exec_cmd("dunstctl close-all"))

bind({ root.mod, "U" }, hl.dsp.exec_cmd(root.scripts .. "/hypridle-toggle.sh"))

bind({ root.mod, "mouse:272" }, hl.dsp.window.drag())
bind({ root.mod, "mouse:273" }, hl.dsp.window.resize())

bind({ "XF86PowerOff" }, hl.dsp.exec_cmd("hyprlock"))

bind({ "XF86AudioMute" }, hl.dsp.exec_cmd("volume-brightness.nu mute toggle"))
bind({ "XF86AudioLowerVolume" }, hl.dsp.exec_cmd("volume-brightness.nu volume down"))
bind({ "XF86AudioRaiseVolume" }, hl.dsp.exec_cmd("volume-brightness.nu volume up"))
bind({ "XF86AudioMicMute" }, hl.dsp.exec_cmd("volume-brightness.nu microphones toggle"))
bind({ "XF86MonBrightnessDown" }, hl.dsp.exec_cmd("volume-brightness.nu brightness down"))
bind({ "XF86MonBrightnessUp" }, hl.dsp.exec_cmd("volume-brightness.nu brightness up"))

bind({ "XF86AudioPause" }, hl.dsp.exec_cmd("playerctl play-pause"))
bind({ "XF86AudioPlay" }, hl.dsp.exec_cmd("playerctl play-pause"))
bind({ "XF86AudioPrev" }, hl.dsp.exec_cmd("playerctl previous"))
bind({ "XF86AudioNext" }, hl.dsp.exec_cmd("playerctl next"))

bind({ "CTRL", "backslash" }, hl.dsp.exec_cmd("playerctl -p " .. root.player .. " play-pause"))
bind({ "CTRL", "SHIFT", "backslash" }, hl.dsp.exec_cmd("playerctl --all-config.config.player pause"))
bind({ "CTRL", "SHIFT", "bracketleft" }, hl.dsp.exec_cmd("playerctl -p " .. root.player .. " previous"))
bind({ "CTRL", "SHIFT", "bracketright" }, hl.dsp.exec_cmd("playerctl -p " .. root.player .. " next"))

local global_binds = {
	{
		window = "class:^(com\\.obsproject\\.Studio)$",
		binds = {
			{ root.mod, "F10" },
			{ root.mod, "F11" },
			{ root.mod, "F12" },
		},
	},
}

for _, item in ipairs(global_binds) do
	for _, keys in ipairs(item.binds) do
		bind(keys, hl.dsp.pass { window = item.window })
	end
end
