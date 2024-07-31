local Source = require("codeium.source")

function Source:is_codeium_enabled()
    local enabled = vim.b["codeium_enabled"]
    if enabled == nil then
        enabled = vim.g["codeium_enabled"]
        if enabled == nil then
            enabled = true -- enable by default
        end
    end
    return enabled
end

---@diagnostic disable-next-line: duplicate-set-field
function Source:is_available()
    local enabled = Source:is_codeium_enabled()
    ---@diagnostic disable-next-line: undefined-field
    return enabled and self.server.is_healthy()
end

vim.api.nvim_set_keymap("n", "<leader>ct", "", {
    callback = function()
        local new_enabled = not Source:is_codeium_enabled()
        vim.b["codeium_enabled"] = new_enabled
        if new_enabled then
            vim.notify("Codeium enabled in buffer")
        else
            vim.notify("Codeium disabled in buffer")
        end
    end,
    noremap = true,
    desc = "Toggle code completion"
})
