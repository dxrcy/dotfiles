local root = require("src")
local sw = root.sw

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
	move = { 0, 0 },
	monitor = root.monitor1,
	stay_focused = true,
	border_size = 0,
	fullscreen_state = "0 0",
}

hl.window_rule {
	name = "windscribe",
	match = { class = "Windscribe" },
	-- float = true,
	-- center = true,
	-- size = { 300, 300 },
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

hl.window_rule {
	name = "pin",
	match = { pin = true },
	border_size = 2,
	border_color = "0x9b8921ff 0xff33125b",
}

for _, program in ipairs(sw.programs) do
	hl.window_rule {
		name = "special:" .. program.name,
		match = { class = program.class },
		workspace = "special:" .. program.name,
	}
end
