return {
    { -- Formatter
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end,
                mode = "",
                desc = "[F]ormat buffer",
            },
        },
        opts = {
            notify_on_error = false,

            formatters = {
                superhtml = {
                    inherit = false,
                    command = "superhtml",
                    stdin = true,
                    args = { "fmt", "--stdin-super" },
                },
                ziggy = {
                    inherit = false,
                    command = "ziggy",
                    stdin = true,
                    args = { "fmt", "--stdin" },
                },
                ziggy_schema = {
                    inherit = false,
                    command = "ziggy",
                    stdin = true,
                    args = { "fmt", "--stdin-schema" },
                },
            },

            formatters_by_ft = {
                shtml = { "superhtml" },
                xml = { "superhtml" },
                ziggy = { "ziggy" },
                ziggy_schema = { "ziggy_schema" },
            },
        },
    },
}
