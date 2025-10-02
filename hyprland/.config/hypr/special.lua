---@class Program
---@field name string
---@field class string
---@field command string
---@field autostart integer|nil

---@type Program[]
Programs = {
    {
        name = "mail",
        class = "Mailspring",
        command = "mailspring --password-store=gnome-libsecret",
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

RecentFile = "/tmp/special.recent"

---@return nil
function PrintUsage()
    print([[
USAGE:
    lua special.lua <NAME>
    lua special.lua <OPTION>

OPTIONS:
    <NAME>
        Show a specific program, starting it if necessary
    --recent
        Show/hide most recently-interacted program
    --hide-all
        Hide all programs
    --autostart
        Start applicable programs, hidden
    --list
        Display all program configuration
    --list-json
        Display all program configuration, as JSON
]])
end

EXIT_CLI = 1
EXIT_COMMAND = 2
EXIT_FILE = 3
EXIT_NO_PROGRAM = 4

---@return nil
local function main()
    local name = arg[1]

    if name == nil then
        PrintUsage()
        os.exit(EXIT_CLI)
    elseif name:sub(1, 1) == "-" then
        if name == "--recent" then
            ToggleRecentProgram()
        elseif name == "--hide-all" then
            HideAllPrograms()
        elseif name == "--autostart" then
            AutostartPrograms()
        elseif name == "--list" then
            ListPrograms(false)
        elseif name == "--list-json" then
            ListPrograms(true)
        else
            PrintUsage()
            os.exit(EXIT_CLI)
        end
    else
        local program = FindProgram(name)
        if program == nil then
            EprintProgram(name, "no such program")
            os.exit(EXIT_NO_PROGRAM)
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
        os.exit(EXIT_NO_PROGRAM)
    end
    -- Assume already running
    ToggleProgram(program)
end

---@return nil
function HideAllPrograms()
    for _, program in ipairs(GetVisiblePrograms()) do
        ToggleProgram(program)
    end
end

---@return nil
function AutostartPrograms()
    for _, program in ipairs(Programs) do
        if
            program.autostart ~= nil
            and not IsProgramRunning(program)
        then
            StartProgram(program, program.autostart, true)
        end
    end
end

---@param json boolean
---@return nil
function ListPrograms(json)
    if json then
        io.write("[")
        for i, program in ipairs(Programs) do
            if i > 1 then
                io.write(",")
            end
            print("{")
            print('    "name": "' .. program.name .. '",')
            print('    "class": "' .. program.class .. '",')
            print('    "command": "' .. program.command .. '",')
            print('    "autostart": ' .. ToStringOr(program.autostart, "null"))
            io.write("}")
        end
        print("]")
    else
        for _, program in ipairs(Programs) do
            print(program.name)
            print("    class: " .. program.class)
            print("    command: " .. program.command)
            print('    autostart: ' .. ToStringOr(program.autostart, "none"))
        end
    end
end

---@generic T
---@param value T
---@param fallback string
---@return string
function ToStringOr(value, fallback)
    if value == nil then
        return fallback
    end
    return tostring(value)
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
        os.exit(EXIT_COMMAND)
    end
end

---@param program Program
---@return boolean
function IsProgramRunning(program)
    local handle = io.popen(
        "hyprctl clients -j "
        .. "| jq -r '.[]"
        .. "    | select(.class == \"" .. program.class .. "\")"
        .. "    | .address"
        .. "'"
    )
    if handle == nil then
        EprintProgram(program.name, "failed to get running status")
        os.exit(EXIT_COMMAND)
    end
    local output = handle:read("*a")
    return #output > 0
end

---@return Program[]
function GetVisiblePrograms()
    local handle = io.popen(
        "hyprctl monitors -j "
        .. "| jq -r '.[]"
        .. "    | select(.focused == true)"
        .. "    | .specialWorkspace.name"
        .. "'"
    )
    if handle == nil then
        Eprint("failed to get visible special workspaces")
        os.exit(EXIT_COMMAND)
    end
    -- Collect names without "special:" prefix
    local names = {}
    for line in handle:lines() do
        local name = string.sub(line, 9, -1)
        if #name > 0 then
            table.insert(names, name)
        end
    end
    -- Filter programs by name
    local programs = {}
    for _, program in ipairs(Programs) do
        for _, name in ipairs(names) do
            if name == program.name then
                table.insert(programs, program)
                break
            end
        end
    end
    return programs
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
        os.exit(EXIT_COMMAND)
    end
end

---@return string
function GetRecentProgramName()
    local line = io.open(RecentFile, "r")
    if line == nil then
        Eprint("failed to read recent file")
        os.exit(EXIT_FILE)
    end
    local name = line:read()
    line:close()
    if name == nil then
        Eprint("failed to read recent file")
        os.exit(EXIT_FILE)
    end
    return name
end

---@param program Program
---@return nil
function WriteRecentProgram(program)
    local file = io.open(RecentFile, "w")
    if file == nil then
        Eprint("failed to write recent file")
        os.exit(EXIT_FILE)
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
    io.write("[" .. name .. "] ")
    io.write(...)
    io.write("\n")
end

main()
