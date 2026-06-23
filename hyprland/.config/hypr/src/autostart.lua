local root = require("src")

-- PERF: Maybe add some sleeps between exec_cmd calls ?
return function()
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("dunst")
	hl.exec_cmd("clipse -listen")

	hl.exec_cmd("killall hypridle; hypridle")

	-- FIXME: This crashes hyprland on start
	-- hl.exec_cmd("sleep 1; hyprpm reload")

	hl.exec_cmd("wpaperd")
	hl.exec_cmd("hyprsunset")
	hl.exec_cmd("wvkbd-mobintl --hidden -L 250")

	hl.timer(function()
		hl.exec_cmd("bt mute-if-disconnected")
		hl.exec_cmd("volume-brightness.nu microphones disable")
	end, { type = "oneshot", timeout = 1000 })

	hl.exec_cmd(root.browser, { workspace = "1 silent" })

	hl.dispatch(function()
		hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland")
		hl.timer(function()
			hl.exec_cmd("/usr/lib/xdg-desktop-portal")
		end, { type = "oneshot", timeout = 2000 })
	end)

	hl.dispatch(hl.dsp.focus { workspace = 2 })

	root.sw.autostart_programs()
end
