function Color(color)
    -- Color scheme
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)
    -- Transparent Background
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

Color()
