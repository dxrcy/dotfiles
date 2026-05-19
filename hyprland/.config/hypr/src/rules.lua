local root = require("src")

hl.window_rule({
	name = "popup",
	match = { class = "popup" },
	float = true,
	center = true,
	size = { 400, 400 },
	stay_focused = true,
})

hl.window_rule({
	name = "popup-clipse",
	match = { class = "popup-clipse" },
	float = true,
	center = true,
	size = { 622, 652 },
	stay_focused = true,
})

hl.window_rule({
	name = "flameshot",
	match = { class = "flameshot" },
	float = true,
	pin = true,
	size = { 0, 0 },
	monitor = root.monitor1,
	stay_focused = true,
	border_size = 0,
})

hl.window_rule({
	name = "windscribe",
	match = { class = "Windscribe" },
	float = true,
	center = true,
	size = { 300, 300 },
})

hl.window_rule({
	name = "firefox-pip",
	match = { class = "Picture-in-Picture" },
	float = true,
	move = { "(monitor_w-window_w-10)", 10 },
	size = { 420, 240 },
})

hl.window_rule({
	name = "minecraft",
	match = { class = "Minecraft\\*.*" },
	tile = true,
})

hl.window_rule({
	name = "ferdium",
	match = { class = "Ferdium" },
	fullscreen_state = 0,
})

-- TODO: Move to sw.lua
hl.window_rule({
	name = "special:mail",
	match = { class = "Mailspring" },
	workspace = "special:mail",
})
hl.window_rule({
	name = "special:spotify",
	match = { class = "Spotify" },
	workspace = "special:music",
})
hl.window_rule({
	name = "special:social",
	match = { class = "Ferdium" },
	workspace = "special:social",
})
hl.window_rule({
	name = "special:vpn",
	match = { class = "Windscribe" },
	workspace = "special:vpn",
})
