return { -- Highlight todo, notes, etc in comments
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VimEnter",
    lazy = false,
    config = function()
        require("todo-comments").setup({
            highlight = {
                pattern = [[.*<((KEYWORDS).*)\s*:]],
            },
            search = {
                pattern = [[\b(KEYWORDS)(\(.*\))?:]],
            },
        })
    end,
}
