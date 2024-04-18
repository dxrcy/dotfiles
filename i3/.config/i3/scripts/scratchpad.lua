Apps = {
    {
        name = "spotify",
        title = "🎮 Spotify",
        command = "spotify",
        class = "spotify",
        size = { 400, 200 },
    },
    {
        name = "discord",
        title = "🎮 Discord",
        command = "webcord",
        class = "webcord",
        size = { 1400, 950 },
    },
    {
        name = "windscribe",
        title = "🌐 Windscribe",
        command = "windscribe",
        class = "windscribe",
    },
}

ToggleScriptFile = "~/.config/i3/scripts/scratchpad-toggle"

function Main()
    if #arg == 0 then
        PrintUsage()
        os.exit(1)
    end

    local subcommand = arg[1]
    if subcommand == "init" then
        InitConfig()
    elseif
        subcommand == "choose" then
        ChooseApp()
    elseif subcommand == "toggle" then
        if #arg < 2 then
            PrintUsage()
            os.exit(1)
        end
        ToggleApp(arg[2])
    elseif subcommand == "hide-all" then
        print("NOT YET IMPLEMENTED")
        os.exit(1)
    else
        PrintUsage()
        os.exit(1)
    end
end

function PrintUsage()
    print("Usage: idk...")
end

function InitConfig()
    for _, app in ipairs(Apps) do
        local config = {
            "floating enable",
            "move scratchpad",
        }
        if app.size ~= nil then
            table.insert(config, "resize set " .. app.size[1] .. " " .. app.size[2])
        end
        if #config > 0 then
            os.execute(
                "i3-msg" ..
                " " ..
                Quote("[class=\"" .. app.class .. "\"]") ..
                " " ..
                table.concat(config, ", ")
            )
        end
    end
end

function ChooseApp()
    local options = ""
    for i, app in ipairs(Apps) do
        if i > 1 then options = options .. "\n" end
        options = options .. app.title
    end

    local response = Execute("echo", Quote(options), "|", "rofi", "-dmenu", "-i")
    response = Trim(response)

    if response == "" then
        print("cancelled")
        os.exit(0)
    end

    local app = FindAppFromTitle(response)
    if app == nil then
        print("app not found! this is unexpected!")
        os.exit(1)
    end

    ExecuteToggleCommand(app);
end

function ToggleApp(name)
    local app = FindAppFromName(name)
    if app == nil then
        print("no app with that name")
        os.exit(1)
    end
    ExecuteToggleCommand(app)
end

function ExecuteToggleCommand(app)
    Execute(ToggleScriptFile, app.class, app.command);
end

function Execute(command, ...)
    for _, arg in ipairs({ ... }) do
        command = command .. " " .. arg
    end

    local handle = io.popen(command)
    if handle == nil then
        os.exit(1)
    end
    local result = handle:read("*a")
    handle:close()
    return result
end

function Quote(string)
    return "'" .. string .. "'"
end

function FindAppFromName(name)
    for _, app in ipairs(Apps) do
        if app.name == name then
            return app
        end
    end
    return nil
end

function FindAppFromTitle(title)
    for _, app in ipairs(Apps) do
        if app.title == title then
            return app
        end
    end
    return nil
end

function Trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

Main()
