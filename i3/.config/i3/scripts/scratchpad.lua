Apps = {
    {
        name = "thunderbird",
        title = "📧 Thunderbird",
        command = "thunderbird",
        instance = "Mail",
        size = { 1300, 900 },
        config = {
            "move scratchpad",
            "move position center",
            "border pixel 2",
        },
    },
    {
        name = "spotify",
        title = "🎮 Spotify",
        command = "spotify",
        instance = "spotify",
        size = { 400, 200 },
    },
    {
        name = "discord",
        title = "🎮 Discord",
        command = "webcord",
        instance = "webcord",
        size = { 1400, 950 },
    },
    {
        name = "windscribe",
        title = "🌐 Windscribe",
        command = "windscribe",
        instance = "windscribe",
        config = {
            "move scratchpad",
        },
    },
    {
        name = "telegram",
        title = "💬 Telegram",
        command = "telegram-desktop",
        instance = "telegram-desktop",
        size = { 1400, 950 },
    },
    {
        name = "calculator",
        title = "🧮 Calculator",
        command =
        "kitty --class 'scratchpad-calculator' -o window_padding_width=2 sh -c 'title -w43 Calculator | lolcat && qalc'",
        instance = "scratchpad-calculator",
        size = { 400, 600 }
    }
}

ToggleScriptFile = "~/.config/i3/scripts/scratchpad-toggle"

function Main()
    CheckConfig()

    if #arg == 0 then
        PrintUsage()
        os.exit(0)
    end

    local subcommand = arg[1]
    if subcommand == "init" then
        InitConfig()
    elseif subcommand == "toggle" then
        if #arg < 2 then
            PrintUsage()
            os.exit(1)
        end
        ToggleApp(arg[2])
    elseif subcommand == "choose" then
        ChooseApp()
    elseif subcommand == "hide-all" then
        print("NOT YET IMPLEMENTED")
        os.exit(8)
    else
        PrintUsage()
        os.exit(0)
    end
end

function PrintUsage()
    print("Usage: idk...")
end

-- Type checking for `Apps`
function CheckConfig()
    for i, app in ipairs(Apps) do
        -- name
        if app.name == nil then
            print("WARNING: app has no name [index " .. i .. "]")
        elseif type(app.name) ~= "string" then
            print("WARNING: app name is not a string [index " .. i .. "]")
        else
            -- title
            if app.title == nil then
                print("WARNING: app has no title [" .. app.name .. "]");
            elseif type(app.title) ~= "string" then
                print("WARNING: app title is not a string [" .. app.name .. "]");
            end
            -- command
            if app.command == nil then
                print("WARNING: app has no command [" .. app.name .. "]");
            elseif type(app.command) ~= "string" then
                print("WARNING: app command is not a string [" .. app.name .. "]");
            end
            -- instance, class
            if app.instance ~= nil and app.class ~= nil then
                print("WARNING: cannot use `instance` with `class` [" .. app.name .. "]")
            elseif app.instance == nil and app.class == nil then
                print("WARNING: neither `instance` nor `class` specified [" .. app.name .. "]")
            elseif type(app.instance or app.class) ~= "string" then
                print("WARNING: app instance or class is not a string [" .. app.name .. "]");
            end
            -- size
            if app.size ~= nil then
                if type(app.size) ~= "table" then
                    print("WARNING: app size is not a table [" .. app.name .. "]");
                elseif #app.size ~= 2 then
                    print("WARNING: app size is not a 2 element table [" .. app.name .. "]");
                elseif type(app.size[1]) ~= "number" or type(app.size[2]) ~= "number" then
                    print("WARNING: app size is not a number table [" .. app.name .. "]");
                end
            end
            -- config
            if app.config ~= nil then
                if type(app.config) ~= "table" then
                    print("WARNING: app config is not a table [" .. app.name .. "]");
                else
                    for _, config in ipairs(app.config) do
                        if type(config) ~= "string" then
                            print("WARNING: app config is not a string table [" .. app.name .. "]");
                        end
                    end
                end
            end
        end
    end
end

function InitConfig()
    for _, app in ipairs(Apps) do
        local config = app.config or {
            -- "floating enable",
            "move scratchpad",
            "move position center",
            "border pixel 2",
        }

        if app.size ~= nil then
            table.insert(config, "resize set " .. app.size[1] .. " " .. app.size[2])
        end

        local selector_type = "instance"
        local selector_value = app.instance
        if app.class ~= nil then
            selector_type = "class"
            selector_value = app.class

            -- TODO: Move to a CheckConfig function
            if app.instance ~= nil then
                print("WARNING: cannot use `class` with `instance`")
            end
        end

        if #config > 0 then
            os.execute(
                "i3-msg" ..
                " " ..
                Quote("[" .. selector_type .. "=\"" .. selector_value .. "\"]") ..
                " " ..
                table.concat(config, ", ")
            )
        end
    end
end

function ToggleApp(name)
    local app = FindAppFromName(name)
    if app == nil then
        print("no app with that name")
        os.exit(2)
    end
    ExecuteToggleCommand(app)
end

function ChooseApp()
    local options = ""
    for i, app in ipairs(Apps) do
        if app.title ~= nil then
            if i > 1 then options = options .. "\n" end
            options = options .. app.title
        end
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
        os.exit(3)
    end

    ExecuteToggleCommand(app);
end

-- TODO: Don't use a script file, write logic in Lua
function ExecuteToggleCommand(app)
    if app.instance ~= nil then
        Execute(ToggleScriptFile, "instance", Quote(app.instance), Quote(app.command));
    else
        Execute(ToggleScriptFile, "class", Quote(app.class), Quote(app.command));
    end
end

function Execute(command, ...)
    for _, arg in ipairs({ ... }) do
        command = command .. " " .. arg
    end

    local handle = io.popen(command)
    if handle == nil then
        os.exit(99)
    end
    local result = handle:read("*a")
    handle:close()
    return result
end

function Quote(string)
    return '"' .. string .. '"'
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
