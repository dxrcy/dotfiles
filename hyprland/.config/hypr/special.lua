---@class Program
---@field name string
---@field class string
---@field command string
---@field autostart boolean

---@type Program[]
Programs = {
    {
        name = "mail",
        class = "thunderbird",
        command = "thunderbird",
        autostart = true,
    },
    {
        name = "music",
        class = "Spotify",
        command = "spotify",
        autostart = true,
    },
    {
        name = "social",
        class = "Ferdium",
        command = "ferdium",
        autostart = false,
    },
    {
        name = "vpn",
        class = "Windscribe",
        command = "windscribe",
        autostart = true,
    },
}

---@return nil
function PrintUsage()
    print([[
USAGE:
    lua special.lua [<NAME> | --autostart | --repair]

OPTIONS:
    <NAME>
        Open a specific program
    --autostart
        Start programs silently
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
        if name == "--autostart" then
            AutostartPrograms()
        elseif name == "--repair" then
            Eprint("[unimplemented]")
            os.exit(1)
        else
            PrintUsage()
            os.exit(1)
        end
    else
        local program = FindProgram(name)
        if program == nil then
            Eprint("No such program")
            os.exit(1)
        end
        if not IsProgramRunning(program) then
            StartProgram(program, false)
        else
            ToggleProgram(program)
        end
    end
end

---@param ...string|number
function Eprint(...)
    io.stderr:write(...)
    io.stderr:write("\n")
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

---@return nil
function AutostartPrograms()
    for _, program in ipairs(Programs) do
        if program.autostart and not IsProgramRunning(program) then
            StartProgram(program, true)
        end
    end
end

---@param program Program
---@param silent boolean
---@return nil
function StartProgram(program, silent)
    local silent_option = ""
    if silent then
        silent_option = "silent"
    end

    print("Executing...")
    local success = os.execute(
        "hyprctl dispatch exec "
        .. "[workspace special:" .. program.name .. " " ..
        silent_option .. "] '"
        .. program.command .. "'"
    )
    if not success then
        Eprint("Failed to run command")
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
        Eprint("Failed to run command")
        os.exit(2)
    end
    local output = handle:read("*a")
    return #output > 0
end

---@param program Program
---@return nil
function ToggleProgram(program)
    local success = os.execute(
        "hyprctl dispatch togglespecialworkspace " ..
        "'" .. program.name .. "'"
    )
    if not success then
        Eprint("Failed to run command")
        os.exit(2)
    end
end

main()