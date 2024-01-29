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
    -- For gitsigns plugin
    -- ?? Makes gitsigns text color white
    -- vim.cmd([[highlight SignColumn     guibg=NONE]])
    -- vim.cmd([[highlight GitSignsAdd    guibg=NONE]])
    -- vim.cmd([[highlight GitSignsChange guibg=NONE]])
    -- vim.cmd([[highlight GitSignsDelete guibg=NONE]])
end

Color()
