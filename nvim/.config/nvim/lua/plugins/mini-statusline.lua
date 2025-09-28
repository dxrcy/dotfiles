return {
    { -- Minimal and fast statusline
        "nvim-mini/mini.statusline",
        version = "*",

        init = function()
            require("mini.statusline").setup({
                use_icons = true,
            })
        end
    },
}
