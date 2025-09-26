return {
    { -- Manage files in a tree
        "nvim-neo-tree/neo-tree.nvim",
        version = "*",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        cmd = "Neotree",
        keys = {
            { "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
        },
        opts = {
            filesystem = {
                window = {
                    mappings = {
                        ["\\"] = "close_window",
                    },
                },
            },
            event_handlers = {
                {
                    event = "file_opened",
                    handler = function()
                        require("neo-tree").close_all()
                    end,
                },
            },
        },
    },
}
