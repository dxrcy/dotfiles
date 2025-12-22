return { -- Colorscheme selection
    "webhooked/kanso.nvim",
    priority = 1000,
    init = function()
        vim.cmd.colorscheme("kanso-zen")
    end,
    opts = {
        transparent = true,
    },
}
