require('nvim-treesitter.configs').setup {
    -- A list of parser names, or "all"
    ensure_installed = {
        -- """Mandatory"""
        "c", "lua", "vim", "vimdoc", "query",
        -- Other languages
        "rust", "go"
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (for "all")
    -- ignore_install = { "javascript" },

    highlight = {
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

-- Custom filetypes
-- ln -s ~/code/tree-sitter-{name}/queries ~/.config/nvim/queries/{name}
parser_config.phonet = {
    install_info = {
        url = "~/code/tree-sitter/tree-sitter-phonet", -- local path or git repo
        files = { "src/parser.c" },        -- note that some parsers also require src/scanner.c or src/scanner.cc
    },
}
parser_config.transcript = {
    install_info = {
        url = "~/code/tree-sitter/tree-sitter-transcript", -- local path or git repo
        files = { "src/parser.c" },            -- note that some parsers also require src/scanner.c or src/scanner.cc
    },
}
parser_config.asmish = {
    install_info = {
        url = "~/code/tree-sitter/tree-sitter-asmish", -- local path or git repo
        files = { "src/parser.c" },        -- note that some parsers also require src/scanner.c or src/scanner.cc
    },
}
parser_config.lispthing = {
    install_info = {
        url = "~/code/tree-sitter/tree-sitter-lispthing", -- local path or git repo
        files = { "src/parser.c" },        -- note that some parsers also require src/scanner.c or src/scanner.cc
    },
}
parser_config.lure = {
    install_info = {
        url = "~/code/tree-sitter/tree-sitter-lure", -- local path or git repo
        files = { "src/parser.c" },        -- note that some parsers also require src/scanner.c or src/scanner.cc
    },
}
