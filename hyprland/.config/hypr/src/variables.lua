local root = require("src")

hl.config {
	general = {
		border_size = 1,
		gaps_in = 3,
		gaps_out = 4,

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
			enabled = root.fancy,
		},
		shadow = {
			enabled = root.fancy,
		},
	},

	animations = {
		enabled = root.fancy,
	},

	input = {
		sensitivity = 0.1,
		float_switch_override_focus = 0,

		touchpad = {
			disable_while_typing = false,
			natural_scroll = true,
			drag_lock = true,
			flip_x = root.weird,
			flip_y = root.weird,
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
