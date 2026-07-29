local root = require("src")

-- PERF: Maybe add some sleeps between exec_cmd calls ?
---@param first boolean
---@return nil
return function(first)
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
	end, { type = "oneshot", timeout = 200 })

	if first then
		hl.exec_cmd(root.browser, { workspace = "1 silent" })
	end

	hl.dispatch(function()
		hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland")
		hl.timer(function()
			hl.exec_cmd("/usr/lib/xdg-desktop-portal")
		end, { type = "oneshot", timeout = 2000 })
	end)

	if first then
		hl.dispatch(hl.dsp.focus { workspace = 2 })
	end

	root.sw.autostart_programs()
end
