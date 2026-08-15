local M = {}

---@param keys string[]
---@param dispatcher (fun(): nil) | HL.Dispatcher
---@param opts? HL.BindOptions
---@return nil
M.bind = function(keys, dispatcher, opts)
	hl.bind(table.concat(keys, " + "), dispatcher, opts)
end

---@param keys string[]
---@param dispatcher (fun(): nil) | HL.Dispatcher
---@param opts? HL.BindOptions
---@return nil
M.bind2 = function(keys, dispatcher, opts)
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
		M.bind(keys, dispatcher, opts)
	end
	M.bind(keys_alt, dispatcher, opts)
end

---@return nil
M.toggle_float = function()
	hl.dispatch(hl.dsp.window.pin { action = "disable" })
	hl.dispatch(hl.dsp.window.float { action = "toggle" })
	hl.dispatch(hl.dsp.window.resize { x = 1200, y = 800 })
end

---@return nil
M.toggle_popup_float = function()
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
end

---@return nil
M.toggle_weird = function()
	local weird = not (
		hl.get_config("input.touchpad.flip_x") or hl.get_config("input.touchpad.flip_y")
	)
	hl.config { input = { touchpad = { flip_x = weird, flip_y = weird } } }
	hl.exec_cmd(
		"notify-send -t 1000 -r 8124 'set cursor direction to "
		.. (weird and "weird" or "normal")
		.. "'"
	)
end

---@return boolean
M.is_swallow = function()
	return hl.get_config("misc.swallow_regex") ~= ""
end

---@param enabled boolean
---@return nil
M.set_swallow = function(enabled)
	-- TODO: Get regex string from `variables.lua` or some shared definition
	hl.config { misc = { swallow_regex = enabled and "^.*$" or "" } }
end

---@return nil
M.toggle_swallow = function()
	local enabled = M.is_swallow()
	hl.exec_cmd("notify-send -t 1000 -r 7915 'Window swallowing " ..
		(enabled and "DISABLED" or "ENABLED") .. "'")
	M.set_swallow(not enabled)
end

---@return nil
M.set_oneshot_swallow = function()
	if not M.is_swallow() then return end
	M.set_swallow(false)
	hl.timer(function()
		M.set_swallow(true)
	end, { type = "oneshot", timeout = 2000 })
end

---@return nil
M.switch_kb_layout = function()
	local kb_layout = hl.get_config("input.kb_layout") ~= "us" and "us" or "epo"
	hl.config { input = { kb_layout = kb_layout } }
end

return M
