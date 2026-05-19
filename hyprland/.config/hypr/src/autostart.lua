local root = require("src")

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

	hl.exec_cmd(root.browser, { workspace = "1 silent" })

	hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland \
        & sleep 2 & /usr/lib/xdg-desktop-portal")

	hl.dispatch(hl.dsp.focus({ workspace = 2 }))

	root.sw.autostart_programs()
end)
