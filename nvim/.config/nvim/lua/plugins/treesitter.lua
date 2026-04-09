return { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",

    config = function()
        require("nvim-treesitter").setup()

        -- Manual version of "ensure_installed" and "auto_install" for 'main' branch rewrite
        require("nvim-treesitter").install({
            "zig",
            "rust",
            "bash",
            "python",
            "cpp",
            "c",
            "diff",
            "html",
            "css",
            "lua",
            "luadoc",
            "markdown",
            "markdown_inline",
            "query",
            "vim",
            "vimdoc",
        })

        -- Manual version of "highlight = {enabled = true}" and "indent = {enabled = true}"
        vim.api.nvim_create_autocmd("FileType", {
            desc = "Enable treesitter in supported buffers",
            callback = function()
                pcall(vim.treesitter.start)
                -- Use treesitter indentation
                -- vim.bo.indentexpr = "v:lua require('nvim-treesitter').indentexpr()"
            end,
        })

        require("nvim-treesitter.parsers").lc3 = {
            install_info = {
                path = "~/code/tree-sitter/tree-sitter-lc3",
            },
        }

        vim.filetype.add({ extension = { asm = "lc3" } })
    end

}
