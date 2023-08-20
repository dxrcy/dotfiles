require("lsp-format").setup {
    markdown = {{ cmd = { "mdformat" } }}
}

require("lspconfig").gopls.setup { on_attach = require("lsp-format").on_attach }

