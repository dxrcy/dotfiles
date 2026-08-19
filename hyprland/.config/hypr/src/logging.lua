local M = {}

local FILEPATH = "/tmp/hypr.log"

---@param level "info"|"warn"|"err"
---@param scopes string[]
---@param message string
M.log = function(level, scopes, message)
	local name = ""
	for _, scope in ipairs(scopes) do
		if #name > 1 then name = name .. "." end
		name = name .. scope
	end
	if #name > 1 then name = "(" .. name .. ")" end

	local line = ""
	line = line .. os.date("%Y-%m-%dT%H:%M:%S")
	line = line .. " " .. level:upper()
	line = line .. name
	line = line .. ": " .. tostring(message)

	local file, _ = io.open(FILEPATH, "a")
	if file then
		file:write(line, "\n")
		file:close()
	end
end

return M
