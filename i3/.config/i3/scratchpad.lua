Apps = {
    {
        name = "terminal",
        title = "🐚 Terminal",
        command = 'kitty --class "scratchpad-terminal" tmux',
        instance = "scratchpad-terminal",
        size = { 800, 400 },
    },
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
        autostart = true,
    },
    {
        name = "spotify",
        title = "🎵 Spotify",
        command = "spotify",
        instance = "spotify",
        size = { 400, 200 },
        autostart = true,
    },
    {
        name = "discord",
        title = "🎮 Discord",
        command = "webcord",
        instance = "webcord",
        size = { 1400, 950 },
    },
    {
        name = "teams",
        title = "💼 Teams",
        command = "teams",
        instance = "microsoft teams - preview",
        size = { 1400, 950 },
    },

    {
        name = "calculator",
        title = "🧮 Calculator",
        command =
        "kitty --class 'scratchpad-calculator' -o window_padding_width=2 sh -c 'title -w43 Calculator | lolcat && qalc'",
        instance = "scratchpad-calculator",
        size = { 400, 600 }
    },

    {
        name = "windscribe",
        title = "🌐 Windscribe",
        command = "windscribe",
        instance = "windscribe",
        config = {
            "move scratchpad",
        },
        autostart = true,
        in_menu = true,
    },
    {
        name = "telegram",
        title = "💬 Telegram",
        command = "telegram-desktop",
        instance = "telegram-desktop",
        size = { 1400, 950 },
        in_menu = true,
    },
    {
        name = "btop",
        title = "📊 Btop",
        command = 'kitty --class "scratchpad-btop" btop',
        instance = "scratchpad-btop",
        size = { 1300, 900 },
        in_menu = true,
    },
}

RecentFilename = "/tmp/scratchpad.recent"

-- TODO: Convert `os.execute` calls to `Execute` ? or other way around ?
-- TODO: Document functions
-- TODO: Add more logging

-- API
---------------------------

function Main()
    CheckConfig()

    local subcommand = arg[1]
    if #arg == 0
        or subcommand == "-h"
        or subcommand == "--help"
        or subcommand == "help"
    then
        PrintUsage()
        os.exit(0)
    end

    if subcommand == "apply" then
        ApplyAllConfig()
    elseif subcommand == "autostart" then
        AutostartApps()
    elseif subcommand == "toggle" then
        if #arg < 2 then
            PrintUsage()
            os.exit(1)
        end
        ToggleApp(arg[2])
    elseif subcommand == "choose" then
        ChooseApp()
    elseif subcommand == "hide-active" then
        HideActive()
    elseif subcommand == "hide-all" then
        print("NOT YET IMPLEMENTED")
        os.exit(88)
    else
        PrintUsage()
        os.exit(1)
    end
end

function PrintUsage()
    print("scratchpad.lua: A configured scratchpad manager for i3")
    print()
    print("USAGE:")
    print("    lua scratchpad.lua [SUBCOMMAND]")
    print()
    print("SUBCOMMAND:")
    print("    apply")
    print("        Reapply config for all apps")
    print("    autostart")
    print("        Autostart apps with `autostart = true`")
    print("    toggle [APP]")
    print("        Toggle visibility of an app")
    print("    choose")
    print("        Open dialog to choose an app to toggle")
    print("    hide-active")
    print("        Hide focused app")
    print("        (Not yet implemented)")
    print("    hide-all")
    print("        Hide all apps")
    print("        (Not yet implemented)")
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
            -- autostart
            if app.autostart ~= nil and type(app.autostart) ~= "boolean" then
                print("WARNING: app autostart is not a boolean [" .. app.name .. "]");
            end
            -- in_menu
            if app.in_menu ~= nil and type(app.in_menu) ~= "boolean" then
                print("WARNING: app in_menu is not a boolean [" .. app.name .. "]");
            end
            -- Unknown key
            for key in pairs(app) do
                if key ~= "name"
                    and key ~= "title"
                    and key ~= "command"
                    and key ~= "instance"
                    and key ~= "class"
                    and key ~= "size"
                    and key ~= "config"
                    and key ~= "autostart"
                    and key ~= "in_menu"
                then
                    print("WARNING: unknown key '" .. key .. "' in app [" .. app.name .. "]")
                end
            end
        end
    end
end

-- API SUBCOMMANDS
---------------------------

function ApplyAllConfig()
    for _, app in ipairs(Apps) do
        ApplyConfig(app)
    end
end

function ApplyConfig(app)
    local config = app.config or {
        -- "floating enable",
        "move scratchpad",
        "move position center",
        "border pixel 2",
    }

    if app.size ~= nil then
        table.insert(config, "resize set " .. app.size[1] .. " " .. app.size[2])
    end

    local selector_type, selector = GetSelectorNameAndValue(app)

    if #config > 0 then
        os.execute("i3-msg" ..
            " " .. Quote("[" .. selector_type .. "=\"" .. selector .. "\"]") ..
            " " .. table.concat(config, ", ")
        )
    end
end

function AutostartApps()
    for _, app in ipairs(Apps) do
        if app.autostart then
            ExecuteStartAndWait(app, true)
        end
    end
end

function ToggleApp(name)
    local app = FindAppFromName(name)
    if app == nil then
        print("no app with that name")
        os.exit(2)
    end
    ExecuteStartOrToggle(app)
end

function ChooseApp()
    local options = ""
    for _, app in ipairs(Apps) do
        if app.title ~= nil and app.in_menu then
            if options ~= "" then options = options .. "\n" end
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

    ExecuteStartOrToggle(app);
end

function HideActive()
    local line = Execute("xprop", "-id", "$(xdotool getactivewindow)", "|", "grep", " 'WM_CLASS'");
    if line == true then
        return
    end

    local instance, class = ExtractInstanceAndClass(line)

    local app = FindAppFromInstanceOrClass(instance, class);
    if app == nil then
        ShowRecent()
        return
    end

    ExecuteToggleVisibility(app)
end

function ShowRecent()
    local line = io.open(RecentFilename, "r")
    if line == nil then
        return
    end
    local name = line:read()
    line:close()
    if name == nil then
        return
    end
    local app = FindAppFromName(name)
    if app == nil then
        print("App not found with that name")
        return
    end
    ExecuteStartOrToggle(app)
end

-- SYSTEM INTERACTION
---------------------------

function ExecuteStartAndWait(app, toggle_after_start)
    local selector_type, selector = GetSelectorNameAndValue(app)

    os.execute(app.command .. "&")

    -- Continuously try to show
    for _ = 0, 100 do
        Sleep(0.1)

        -- Apply normal config: set as scratchpad (hidden)
        -- This must be done before trying to `scratchpad show`
        ApplyConfig(app)
        -- Show scratchpad
        local exitcode = os.execute("i3-msg" ..
            " " .. Quote("[" .. selector_type .. "=\"" .. selector .. "\"]") ..
            " " .. "scratchpad show, move position center"
        )

        -- Try again if failed to show
        -- Happens if window has not yet opened
        if exitcode == true then
            print("Done.")

            if toggle_after_start then
                ExecuteToggleVisibility(app)
            end
            return
        end
    end

    -- Give up
    local msg = "Failed to show scratchpad after so many attempts."
    print(msg)
    Execute("notify-send", Quote(msg))
    os.exit(4)
end

function ExecuteStartOrToggle(app)
    local visible_wid = GetWindowID(app, true)
    if visible_wid == nil then
        print("No window currently visible...")
        local wid = GetWindowID(app, false)

        -- No window found, spawn new
        if wid == nil then
            print("No window found...")
            ExecuteStartAndWait(app, false)
            return
        end
    end

    ExecuteToggleVisibility(app)
end

-- Hide or Show
function ExecuteToggleVisibility(app)
    local selector_type, selector = GetSelectorNameAndValue(app)

    local file = io.open(RecentFilename, "w")
    if file then
        file:write(app.name)
        file:close()
    end

    print("Toggling visiblity...")
    os.execute("i3-msg" ..
        " " .. Quote("[" .. selector_type .. "=\"" .. selector .. "\"]") ..
        " " .. "scratchpad show, move position center"
    )
end

function GetWindowID(app, only_visible)
    local selector_type, selector = GetSelectorNameAndValue(app, "--classname", "--class")

    local visibility = ""
    if only_visible then
        visibility = "--onlyvisible"
    end

    local wid = Trim(Execute(
        "xdotool", "search", visibility, selector_type, Quote(selector),
        "|", "tail", "-1"
    ))

    if wid == "" then
        return nil
    end
    return wid
end

-- HELPER FUNCTIONS
---------------------------

function Execute(command, ...)
    for _, arg in ipairs({ ... }) do
        command = command .. " " .. arg
    end

    print(command)

    local handle = io.popen(command)
    if handle == nil then
        os.exit(99)
    end
    local result = handle:read("*a")
    local exitcode = handle:close()
    print(exitcode)
    return result, exitcode
end

function Quote(string)
    return "'" .. string .. "'"
end

function Sleep(time)
    Execute("sleep", tonumber(time))
end

function GetSelectorNameAndValue(app, instance_key, class_key)
    if app.instance ~= nil then
        return instance_key or "instance", app.instance
    elseif app.class ~= nil then
        return class_key or "class", app.class
    else
        return nil, nil -- Checked by `CheckConfig`
    end
end

function ExtractInstanceAndClass(line)
    local instance = ""
    local class = ""

    local parts = line:gmatch('"([^"]*)"')
    local i = 0
    for part in parts do
        if i == 0 then
            instance = part
        elseif i == 1 then
            class = part
        else
            break
        end
        i = i + 1
    end
    return instance, class
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

function FindAppFromInstanceOrClass(instance, class)
    for _, app in ipairs(Apps) do
        if app.instance == instance then
            return app
        end
    end
    for _, app in ipairs(Apps) do
        if app.class == class then
            return app
        end
    end
    return nil
end

function Trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

Main()
