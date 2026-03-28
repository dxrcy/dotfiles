return { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    branch = "v0.10.0",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",

    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "zig",
            },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = false },
        })

        local parser_configs = require("nvim-treesitter.parsers")
            .get_parser_configs()

        parser_configs.lc3 = {
            filetype = "lc3",
            install_info = {
                url = "~/code/tree-sitter/tree-sitter-lc3",
                files = { "src/parser.c" },
            },
        }

        vim.filetype.add {
            extension = {
                asm = "lc3",
                lc3 = "lc3",
            },
        }
    end,
}
