local root = require("src")
local sw = root.sw

---@param keys string[]
---@param dispatcher (fun(): nil) | HL.Dispatcher
---@return nil
local function bind(keys, dispatcher)
	local keys_string = root.mod
	for _, key in ipairs(keys) do
		keys_string = keys_string .. " + " .. key
	end

	hl.bind(keys_string, dispatcher)
end

-- Windows

bind({ "Q" }, hl.dsp.window.close())

bind({ "space" }, function()
	-- Hack to stop windows becoming massive after enabling float
	hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
	hl.dispatch(hl.dsp.window.resize({ x = 1200, y = 800 }))
end)
bind({ "F" }, hl.dsp.window.fullscreen())

bind({ "ALT", "H" }, hl.dsp.layout("mfact -0.08"))
bind({ "ALT", "L" }, hl.dsp.layout("mfact +0.08"))
bind({ "ALT", "SHIFT", "H" }, hl.dsp.layout("mfact -0.01"))
bind({ "ALT", "SHIFT", "L" }, hl.dsp.layout("mfact +0.01"))

bind({ "CTRL", "H" }, hl.dsp.focus({ monitor = 0 }))
bind({ "CTRL", "L" }, hl.dsp.focus({ monitor = 1 }))

bind({ "P" }, hl.dsp.window.pin())

bind({ "L" }, hl.dsp.focus({ direction = "right" }))
bind({ "H" }, hl.dsp.focus({ direction = "left" }))
bind({ "K" }, hl.dsp.focus({ direction = "up" }))
bind({ "J" }, hl.dsp.focus({ direction = "down" }))

bind({ "SHIFT", "L" }, hl.dsp.window.move({ direction = "right" }))
bind({ "SHIFT", "H" }, hl.dsp.window.move({ direction = "left" }))
bind({ "SHIFT", "K" }, hl.dsp.window.move({ direction = "up" }))
bind({ "SHIFT", "J" }, hl.dsp.window.move({ direction = "down" }))

-- Workspaces

bind({ "tab" }, hl.dsp.focus({ workspace = "previous" }))

for i = 1, 10 do
	local key = tostring(i % 10)
	bind({ key }, hl.dsp.focus({ workspace = i }))
	bind({ "SHIFT", key }, hl.dsp.window.move({ workspace = i }))
end

bind({ "CTRL", "ALT", "H" }, hl.dsp.workspace.move({ monitor = 0 }))
bind({ "CTRL", "ALT", "L" }, hl.dsp.workspace.move({ monitor = 1 }))

-- Special workspaces

bind({ "grave" }, sw.toggle_recent())

for _, program in ipairs(sw.programs) do
	if program.keybind_toggle then
		bind(program.keybind_toggle, sw.toggle(program.name))
	end
	if program.keybind_move then
		bind(program.keybind_move, sw.move(program.name))
	end
end

-- Applications

bind({ "Return" }, hl.dsp.exec_cmd(root.terminal .. " zellij"))
bind({ "ALT", "Return" }, hl.dsp.exec_cmd(root.terminal .. " sh -c 'zellij attach $(zellij ls --short | tail -n1)'"))
bind(
	{ "CTRL", "Return" },
	hl.dsp.exec_cmd(root.terminal .. ' sh -c \'printf "\\033[1m(no multiplexer)\\n" && ' .. root.shell .. "'")
)

bind({ "O" }, hl.dsp.exec_cmd(root.terminal .. " sh -c 'cd ~/docs/notes && nvim $(notename)'"))

-- Popups

bind({ "D" }, hl.dsp.exec_cmd('$(terminal-popup fzf-menu "$XDG_DATA_HOME/applications-minimal/")'))
bind(
	{ "SHIFT", "D" },
	hl.dsp.exec_cmd('$(terminal-popup fzf-menu "/usr/share/applications/ $XDG_DATA_HOME/applications/")')
)
bind({ "CTRL", "D" }, hl.dsp.exec_cmd("rofi -show drun"))

bind({ "escape" }, hl.dsp.exec_cmd("fzf-powermenu"))

bind({ "period" }, hl.dsp.exec_cmd("wl-copy $(terminal-popup fzf-emoji)"))

bind({ "V" }, hl.dsp.exec_cmd("foot --app-id=popup-clipse -- clipse"))

bind({ "M" }, hl.dsp.exec_cmd("mount-gui --notify"))

-- Misc

hl.bind("print", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))

bind({ "B" }, hl.dsp.exec_cmd("bt connect"))
bind({ "SHIFT", "B" }, hl.dsp.exec_cmd("bt disconnect"))

bind({ "S" }, hl.dsp.exec_cmd("player-info notify"))
bind({ "SHIFT", "S" }, hl.dsp.exec_cmd("dunstify -t 2000 --replace 8428 \"$(date '+%T')\" \"$(date +'%A %-d %B')\""))
bind({ "CTRL", "N" }, hl.dsp.exec_cmd("dunstctl close-all"))

bind({ "U" }, hl.dsp.exec_cmd(root.scripts .. "/hypridle-toggle.sh"))

bind({ "mouse:272" }, hl.dsp.window.drag())
bind({ "mouse:273" }, hl.dsp.window.resize())

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
