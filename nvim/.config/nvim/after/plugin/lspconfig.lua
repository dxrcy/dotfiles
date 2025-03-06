local lspconfig = require('lspconfig')

vim.g.zig_fmt_autosave = 0

lspconfig.rust_analyzer.setup {
    settings = {
        ["rust-analyzer"] = {
            diagnostics = {
                disabled = { "inactive-code" }
            }
        }
    }
}

-- Defaults
lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {
                    'vim',
                    'require'
                },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

lspconfig.clangd.setup {
    cmd = { "clangd", "--compile-commands-dir=./build" }, -- Adjust if necessary
    flags = {
        debounce_text_changes = 150,
    },
    on_attach = function(client, bufnr)
        -- Key mappings, autocompletion setup, etc.
    end,
    settings = {
        clangd = {
            -- Add your GCC flags here
            args = {
                "-Wall",   -- Show all warnings
                "-Werror", -- Treat warnings as errors
                "-Wextra", -- Extra warnings
            }
        }
    }
}

lspconfig.roc_ls.setup {}
