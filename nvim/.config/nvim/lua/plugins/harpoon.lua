return {
    { -- Buffer navigation
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },

        init = function()
            local harpoon = require("harpoon")
            harpoon.setup()

            vim.keymap.set("n", "<leader>a",
                function() harpoon:list():add() end,
                { desc = "Harpoon add" }
            )
            vim.keymap.set("n", "<C-e>",
                function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
                { desc = "Harpoon open menu" }
            )

            for i = 1, 9 do
                vim.keymap.set("n", "<leader>" .. i,
                    function() harpoon:list():select(i) end,
                    { desc = "Harpoon select " .. i }
                )
            end
        end,
    },
}
