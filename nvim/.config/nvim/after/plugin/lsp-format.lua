require("lsp-format").setup {
    markdown = { { cmd = { "mdformat" } } },
}

local lspconfig = require("lspconfig")

-- Go
lspconfig.gopls.setup { on_attach = require("lsp-format").on_attach }

-- C / C++
-- Note: use `.clang-format` file to set formatting options like indent size
lspconfig.clangd.setup {
    cmd = { "clangd", "--clang-tidy", "--fallback-style=Google" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = lspconfig.util.root_pattern(".git", "compile_commands.json"),
    settings = {
        clangd = {
            fallbackStyle = "Google",
            format = { style = "file", executable = "clang-format" },
        }
    }
}
