return { -- Extensible scrollbar
    "petertriho/nvim-scrollbar",
    config = function()
        require("scrollbar").setup({
            handlers = {
                cursor = true,
                diagnostic = true,
                gitsigns = true,
                handle = true,
            },
        })
    end,
}
