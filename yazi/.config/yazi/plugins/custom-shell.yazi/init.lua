local function entry()
    -- Prompt for input
    local value, event = ya.input({
        title = "zsh Shell:",
        position = { "top-center", y = 3, w = 40 },
    })
    -- Cancelled
    if event ~= 1 then
        return
    end

    -- Quit yazi with vim-style commands
    if value == "q" or value == "wq" then
        ya.manager_emit("quit", {})
    end

    -- Run command
    ya.manager_emit("shell", {
        "zsh -ic " .. ya.quote(value .. "; exit", true),
        block = true,
        confirm = true,
    })
end

return {
    entry = entry
}
