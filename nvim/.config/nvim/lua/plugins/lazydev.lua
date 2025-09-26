return {
    { -- Faster LuaLS setup, `vim` global type declaration
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                "~/.local/share/nvim/lazy/",
            },
        },
    },
}
