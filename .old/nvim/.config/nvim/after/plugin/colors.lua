function Color(color)
    -- Color scheme
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    -- Transparent Background
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    -- For unfocused windows
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalSB", { bg = "none" })
    -- Current line background
    vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1e1e2e" })
end

Color()
