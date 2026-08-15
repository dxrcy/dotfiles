-- TODO: Esperanto keyboard equivalent binds
-- TODO: Call scripts directly from lua
-- TODO: Plugin config (keybinds)

local M = {
	fancy = true,
	weird = true,

	mod = "SUPER",
	monitor1 = "eDP-1",

	terminal = "kitty",
	shell = "zsh",
	browser = "$BROWSER",
	player = "spotify",

	scripts = "~/.config/hypr/scripts/",
}

M.run = function()
	require("src.variables")
	require("src.binds")
	require("src.rules")
	-- TODO: Rename to `special`
	require("src.sw")
	local autostart = require("src.autostart")

	hl.on("hyprland.start", function()
		autostart(true)
	end)

	hl.monitor { output = "", mode = "preferred", position = "auto", scale = "auto" }
	hl.monitor { output = M.monitor1, mode = "preferred", position = "auto", scale = "1.6" }

	hl.curve("easeOut", { type = "bezier", points = { { 0.33, 1 }, { 0.68, 1 } } })

	hl.animation { leaf = "global", enabled = true, speed = 1.7, bezier = "easeOut" }
	hl.animation {
		leaf = "workspaces",
		enabled = true,
		speed = 1.8,
		bezier = "easeOut",
		style = "slidevert",
	}
end

return M
