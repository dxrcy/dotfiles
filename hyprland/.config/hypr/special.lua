---@class Program
---@field name string
---@field class string
---@field command string
---@field autostart integer

---@type Program[]
Programs = {
    {
        name = "mail",
        class = "thunderbird",
        command = "thunderbird",
        autostart = 1,
    },
    {
        name = "music",
        class = "Spotify",
        command = "spotify",
        autostart = 0,
    },
    {
        name = "social",
        class = "Ferdium",
        command = "ferdium",
        autostart = 4,
    },
    {
        name = "vpn",
        class = "Windscribe",
        command = "windscribe",
        autostart = 0,
    },
}

RecentFile = "/tmp/special.recent"

---@return nil
function PrintUsage()
    print([[
USAGE:
    lua special.lua <NAME>
    lua special.lua [--recent | --hide-all | --autostart | --repair]

OPTIONS:
    <NAME>
        Show a specific program, starting it if necessary
    --recent
        Show/hide most recently-interacted program
    --hide-all
        Hide all programs
    --autostart
        Start applicable programs, hidden
    --repair
        [unimplemented]
]])
end

---@return nil
local function main()
    local name = arg[1]

    if name == nil then
        PrintUsage()
        os.exit(1)
    elseif name:sub(1, 1) == "-" then
        if name == "--recent" then
            ToggleRecentProgram()
        elseif name == "--hide-all" then
            HideAllPrograms()
        elseif name == "--autostart" then
            AutostartPrograms()
        elseif name == "--repair" then
            Eprint("--repair is unimplemented")
            os.exit(1)
        else
            PrintUsage()
            os.exit(1)
        end
    else
        local program = FindProgram(name)
        if program == nil then
            EprintProgram(name, "no such program")
            os.exit(1)
        end
        if not IsProgramRunning(program) then
            StartProgram(program, 0, false)
        else
            ToggleProgram(program)
        end
    end
end

---@return nil
function ToggleRecentProgram()
    local name = GetRecentProgramName()
    local program = FindProgram(name)
    if program == nil then
        EprintProgram(name, "no such program (from recent)")
        os.exit(2)
    end
    -- Assume already running
    ToggleProgram(program)
end

---@return nil
function HideAllPrograms()
    -- I couldn't find a way to HIDE a special workspace (only TOGGLE visibility)
    -- So we show a non-existant empty workspace, then hide it again
    -- This has the same effect and is unnoticable
    local temp_name = "__TEMP"
    ToggleSpecialWorkspace(temp_name)
    ToggleSpecialWorkspace(temp_name)
end

---@return nil
function AutostartPrograms()
    for _, program in ipairs(Programs) do
        if
            program.autostart >= 0
            and not IsProgramRunning(program)
        then
            StartProgram(program, program.autostart, true)
        end
    end
end

---@param program Program
---@param delay integer
---@param silent boolean
---@return nil
function StartProgram(program, delay, silent)
    PrintProgram(program.name, "starting")

    local silent_option = ""
    if silent then
        silent_option = "silent"
    end

    local command =
        "{\n"
        .. "sleep " .. delay .. ";\n"
        .. "hyprctl dispatch exec "
        .. "[workspace special:" .. program.name .. " "
        .. silent_option .. "] '"
        .. program.command .. "'"
        .. ";\n"
        .. "} &"
    local success = os.execute(command)
    if not success then
        EprintProgram(program.name, "failed to start program")
        os.exit(2)
    end
end

---@param program Program
---@return boolean
function IsProgramRunning(program)
    local handle = io.popen(
        "hyprctl clients -j "
        .. "| jq -r '.[]"
        .. "    | select(.class == \"" .. program.class .. "\")"
        .. "    | .address'"
    )
    if handle == nil then
        EprintProgram(program.name, "failed to get running status")
        os.exit(2)
    end
    local output = handle:read("*a")
    return #output > 0
end

---@param program Program
---@return nil
function ToggleProgram(program)
    PrintProgram(program.name, "toggling visibility")
    ToggleSpecialWorkspace(program.name)
    WriteRecentProgram(program)
end

---@param name string
---@return nil
function ToggleSpecialWorkspace(name)
    local success = os.execute(
        "hyprctl dispatch togglespecialworkspace "
        .. "'" .. name .. "'"
    )
    if not success then
        EprintProgram(name, "failed to toggle visibility")
        os.exit(2)
    end
end

---@return string
function GetRecentProgramName()
    local line = io.open(RecentFile, "r")
    if line == nil then
        Eprint("failed to read recent file")
        os.exit(2)
    end
    local name = line:read()
    line:close()
    if name == nil then
        Eprint("failed to read recent file")
        os.exit(2)
    end
    return name
end

---@param program Program
---@return nil
function WriteRecentProgram(program)
    local file = io.open(RecentFile, "w")
    if file == nil then
        Eprint("failed to write recent file")
        os.exit(2)
    end
    file:write(program.name)
    file:close()
end

---@param name string
---@return Program?
function FindProgram(name)
    for _, program in ipairs(Programs) do
        if program.name == name then
            return program
        end
    end
    return nil
end

---@param ...string|number
function Eprint(...)
    io.stderr:write(...)
    io.stderr:write("\n")
end

---@param name string
---@param ...string|number
function EprintProgram(name, ...)
    io.stderr:write("[" .. name .. "] ")
    io.stderr:write(...)
    io.stderr:write("\n")
end

---@param name string
---@param ...string|number
function PrintProgram(name, ...)
    io.stdout:write("[" .. name .. "] ")
    io.stdout:write(...)
    io.stdout:write("\n")
end

main()
