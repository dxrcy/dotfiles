local root = require("src")
local sw = require("src.sw")
local autostart = require("src.autostart")

---@param keys string[]
---@param dispatcher (fun(): nil) | HL.Dispatcher
---@param opts? HL.BindOptions
---@return nil
local function bind(keys, dispatcher, opts)
	hl.bind(table.concat(keys, " + "), dispatcher, opts)
end

---@param keys string[]
---@param dispatcher (fun(): nil) | HL.Dispatcher
---@param opts? HL.BindOptions
---@return nil
local function bind2(keys, dispatcher, opts)
	local alt_syms = {
		Q = "scircumflex",
		W = "gcircumflex",
		X = "ccircumflex",
		Y = "ubreve",
		bracketleft = "jcircumflex",
		bracketright = "hcircumflex",
	}
	local keys_alt = {}
	for _, key in ipairs(keys) do
		keys_alt[#keys_alt + 1] = alt_syms[key] or key
	end
	if table.concat(keys, " + ") ~= table.concat(keys_alt, " + ") then
		bind(keys, dispatcher, opts)
	end
	bind(keys_alt, dispatcher, opts)
end

-- Windows

bind({ root.mod, "SHIFT", "R" }, function()
	autostart(false)
end)

bind2({ root.mod, "Q" }, hl.dsp.window.close())

bind({ root.mod, "C" }, function()
	local weird = not (
		hl.get_config("input.touchpad.flip_x") or hl.get_config("input.touchpad.flip_y")
	)
	hl.config { input = { touchpad = { flip_x = weird, flip_y = weird } } }
	hl.exec_cmd(
		"notify-send -t 1000 -r 8124 'set cursor direction to "
		.. (weird and "weird" or "normal")
		.. "'"
	)
end)

-- Toggle float, set size and disable pin
bind({ root.mod, "SHIFT", "space" }, function()
	hl.dispatch(hl.dsp.window.pin { action = "disable" })
	hl.dispatch(hl.dsp.window.float { action = "toggle" })
	hl.dispatch(hl.dsp.window.resize { x = 1200, y = 800 })
end)

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

-- Pinned video player
bind({ root.mod, "SHIFT", "P" }, function()
	local window = hl.get_active_window()
	if window == nil then
		return
	end
	if window.floating and window.pinned then
		hl.dispatch(hl.dsp.window.pin { action = "disable" })
		hl.dispatch(hl.dsp.window.float { action = "disable" })
	else
		hl.dispatch(hl.dsp.window.float { action = "enable" })
		hl.dispatch(hl.dsp.window.resize { x = 500, y = 280 })
		hl.dispatch(hl.dsp.window.move { direction = "up" })
		hl.dispatch(hl.dsp.window.move { direction = "right" })
		local gap = 3
		hl.dispatch(hl.dsp.window.move { relative = true, x = -gap, y = gap })
		hl.dispatch(hl.dsp.window.pin { action = "enable" })
	end
end)

bind({ root.mod, "L" }, hl.dsp.focus { direction = "right" })
bind({ root.mod, "H" }, hl.dsp.focus { direction = "left" })
bind({ root.mod, "K" }, hl.dsp.focus { direction = "up" })
bind({ root.mod, "J" }, hl.dsp.focus { direction = "down" })

-- For focusing floating windows
-- TODO: Only toggle between most recent floating window and most recent tiling window
bind({ root.mod, "space" }, hl.dsp.window.cycle_next())

bind({ root.mod, "SHIFT", "L" }, hl.dsp.window.move { direction = "right" })
bind({ root.mod, "SHIFT", "H" }, hl.dsp.window.move { direction = "left" })
bind({ root.mod, "SHIFT", "K" }, hl.dsp.window.move { direction = "up" })
bind({ root.mod, "SHIFT", "J" }, hl.dsp.window.move { direction = "down" })

bind({ root.mod, "N" }, function()
	-- TODO: Get regex string from `variables.lua` or some shared definition
	local swallow_regex = hl.get_config("misc.swallow_regex") == "" and "^.*$" or ""
	hl.exec_cmd("notify-send -t 1000 -r 7915 'Window swallowing " ..
		(swallow_regex == "" and "DISABLED" or "ENABLED") .. "'")
	hl.config { misc = { swallow_regex = swallow_regex } }
end)

-- Workspaces

bind({ root.mod, "tab" }, hl.dsp.focus { workspace = "previous" })

bind({ root.mod, "I" }, hl.dsp.focus { workspace = "-1" })
bind({ root.mod, "O" }, hl.dsp.focus { workspace = "+1" })

for i = 1, 10 do
	local key = tostring(i % 10)
	bind({ root.mod, key }, hl.dsp.focus { workspace = i })
	bind({ root.mod, "SHIFT", key }, hl.dsp.window.move { workspace = i, follow = false })
end

bind({ root.mod, "CTRL", "ALT", "H" }, hl.dsp.workspace.move { monitor = 0 })
bind({ root.mod, "CTRL", "ALT", "L" }, hl.dsp.workspace.move { monitor = 1 })

-- Special workspaces

bind({ root.mod, "grave" }, sw.toggle_recent())

for _, program in ipairs(sw.programs) do
	if program.keybind_toggle then
		bind2(program.keybind_toggle, sw.toggle(program.name))
	end
	if program.keybind_move then
		bind2(program.keybind_move, sw.move(program.name))
	end
end

-- Applications

bind({ root.mod, "Return" }, hl.dsp.exec_cmd(root.terminal .. " herdr --session \"$(namegen '%A-%N')\""))
bind({ root.mod, "ALT", "Return" }, hl.dsp.exec_cmd(root.terminal .. " herdr"))
bind(
	{ root.mod, "CTRL", "Return" },
	hl.dsp.exec_cmd(
		root.terminal .. ' sh -c \'printf "\\033[1m(no multiplexer)\\n" && ' .. root.shell .. "'"
	)
)

bind(
	{ root.mod, "SHIFT", "O" },
	hl.dsp.exec_cmd(root.terminal .. " sh -c 'cd ~/media/notes && nvim $(notename)'")
)

-- Popups

bind({ root.mod, "D" }, hl.dsp.exec_cmd('$(terminal-popup fzf-menu "$XDG_DATA_HOME/applications-minimal/")'))
bind(
	{ root.mod, "SHIFT", "D" },
	hl.dsp.exec_cmd(
		'$(terminal-popup fzf-menu "/usr/share/applications/ $XDG_DATA_HOME/applications/")'
	)
)
bind({ root.mod, "CTRL", "D" }, hl.dsp.exec_cmd("rofi -show drun"))

bind({ root.mod, "escape" }, hl.dsp.exec_cmd("fzf-powermenu"))

bind({ root.mod, "period" }, hl.dsp.exec_cmd("wl-copy $(terminal-popup fzf-emoji)"))

bind({ root.mod, "V" }, hl.dsp.exec_cmd("foot --app-id=popup-clipse -- clipse"))

bind({ root.mod, "M" }, hl.dsp.exec_cmd("mount-gui --notify"))

-- Misc

local function switch_kb_layout()
	local kb_layout = hl.get_config("input.kb_layout") ~= "us" and "us" or "epo"
	hl.config { input = { kb_layout = kb_layout } }
end
bind2({ "ALT", "Q" }, switch_kb_layout, { non_consuming = true })

bind({ "print" }, hl.dsp.exec_cmd("flameshot gui"))
bind({ "SHIFT", "print" }, hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))

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

bind2({ "CTRL", "backslash" }, hl.dsp.exec_cmd("playerctl -p " .. root.player .. " play-pause"))
bind2({ "CTRL", "SHIFT", "backslash" }, hl.dsp.exec_cmd("playerctl --all-config.config.player pause"))
bind2({ "CTRL", "SHIFT", "bracketleft" }, hl.dsp.exec_cmd("playerctl -p " .. root.player .. " previous"))
bind2({ "CTRL", "SHIFT", "bracketright" }, hl.dsp.exec_cmd("playerctl -p " .. root.player .. " next"))

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
		bind2(keys, hl.dsp.pass { window = item.window })
	end
end
