return { -- Autocompletion
    "saghen/blink.cmp",
    event = "VeryLazy",
    version = "1.*",
    dependencies = { "L3MON4D3/LuaSnip" },

    --- @module "blink.cmp"
    --- @type blink.cmp.Config
    opts = {
        keymap = { preset = "default" },

        appearance = {
            nerd_font_variant = "mono",
        },

        completion = {
            documentation = { auto_show = true, auto_show_delay_ms = 500 },
        },

        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },

        fuzzy = { implementation = "prefer_rust_with_warning" },

        snippets = { preset = "luasnip" },
    },
}
