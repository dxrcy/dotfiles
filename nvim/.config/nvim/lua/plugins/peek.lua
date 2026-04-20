return {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    opts = {
        auto_load = false,
    },
    keys = {
        { "<leader>po", function() require("peek").open() end,  desc = "Open Peek preview" },
        { "<leader>pc", function() require("peek").close() end, desc = "Close Peek preview" },
    },
}
