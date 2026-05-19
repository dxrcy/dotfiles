---@class Program
---@field name string
---@field class string
---@field command string
---@field autostart integer|nil

---@type Program[]
local programs = {
	{
		name = "mail",
		class = "Mailspring",
		command = "mailspring --password-store=gnome-libsecret",
		autostart = 5,
	},
	{
		name = "music",
		class = "Spotify",
		command = "spotify",
		autostart = 1,
	},
	{
		name = "social",
		class = "Ferdium",
		command = "ferdium",
		autostart = 20,
	},
	{
		name = "calculator",
		class = "terminal-calculator",
		command = "kitty --app-id terminal-calculator -o font_size=12 qalc",
		autostart = nil,
	},
	{
		name = "vpn",
		class = "Windscribe",
		command = "windscribe",
		autostart = 0,
	},
}

local recent_filepath = "/tmp/sw.recent"
local log_filepath = "/tmp/sw.log"

---@param name string
---@return Program?
local function find_program(name)
	for _, program in ipairs(programs) do
		if program.name == name then
			return program
		end
	end
	return nil
end

---@param level "info"|"warn"|"err"
---@param name string|nil
---@param message string
local function log(level, name, message)
	local line = ""
	line = line .. os.date("%Y-%m-%dT%H:%M:%S")
	line = line .. " " .. level:upper()
	if name then
		line = line .. "(" .. name .. ")"
	end
	line = line .. ": " .. tostring(message)

	local file, _ = io.open(log_filepath, "a")
	if file then
		file:write(line, "\n")
		file:close()
	end
end

---@return string|nil
local function get_recent_name()
	local file = io.open(recent_filepath, "r")
	if file == nil then
		log("err", nil, "failed to read recent file")
		return nil
	end

	local name = file:read()
	file:close()

	if name == nil then
		log("err", nil, "failed to read recent file")
		return nil
	end
	return name
end

---@param program Program
---@return nil
local function write_recent_program(program)
	local file = io.open(recent_filepath, "w")
	if file == nil then
		log("warn", nil, "failed to write recent file")
		return
	end

	file:write(program.name)
	file:close()
end

---@param delay number
---@param callback fun(): nil
---@return nil
local function after(delay, callback)
	if delay == 0 then
		callback()
	else
		hl.timer(callback, { timeout = delay * 1000, type = "oneshot" })
	end
end

---@param program Program
---@param delay integer
---@param silent boolean
---@return nil
local function start_program(program, delay, silent)
	log("info", program.name, "starting")

	local silent_option = ""
	if silent then
		silent_option = " silent"
	end

	after(delay, function()
		hl.dispatch(hl.dsp.exec_cmd(program.command, { workspace = "special:" .. program.name .. silent_option }))
	end)
end

---@param program Program
---@return boolean
local function is_program_running(program)
	for _, window in ipairs(hl.get_windows()) do
		if window.class == program.class then
			return true
		end
	end
	return false
end

---@param program Program
---@return nil
local function toggle_program(program)
	log("info", program.name, "toggling visibility")

	hl.dispatch(hl.dsp.workspace.toggle_special(program.name))
	write_recent_program(program)
end

local M = {}

---@return nil
M.autostart_programs = function()
	log("info", nil, "autostart programs")

	for _, program in ipairs(programs) do
		if program.autostart then
			log("info", program.name, "has autostart")
			if is_program_running(program) then
				log("info", program.name, "already running")
			else
				start_program(program, program.autostart, true)
			end
		end
	end

	log("info", nil, "done")
end

---@param name string
---@return fun(): nil
M.toggle = function(name)
	return function()
		log("info", nil, "toggle '" .. name .. "'")

		local program = find_program(name)
		if program == nil then
			log("err", name, "no such program")
			return
		end
		log("info", program.name, "found")

		local running = is_program_running(program)
		log("info", program.name, "running? " .. tostring(running))

		if running then
			toggle_program(program)
		else
			start_program(program, 0, false)
		end

		log("info", program.name, "done")
	end
end

---@return fun(): nil
M.toggle_recent = function()
	return function()
		log("info", nil, "toggle recent")

		local name = get_recent_name()
		if name == nil then
			return
		end
		log("info", nil, "read '" .. name .. "'")

		local program = find_program(name)
		if program == nil then
			log("err", name, "no such program")
			return
		end
		log("info", program.name, "found")

		-- Assume already running
		toggle_program(program)

		log("info", program.name, "done")
	end
end

return M
