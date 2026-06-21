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

	-- TODO: Rename to `special`
	sw = require("src.sw"),
}

M.run = function()
	require("src.variables")
	require("src.binds")
	require("src.rules")
	require("src.autostart")

	hl.monitor { output = "", mode = "preferred", position = "auto", scale = "auto" }
	hl.monitor { output = M.monitor1, mode = "preferred", position = "auto", scale = "1.6" }

	hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0 }, { 0.35, 1 } } })
	hl.animation { leaf = "global", enabled = true, speed = 1.7, bezier = "easeInOutCubic" }
end

return M
