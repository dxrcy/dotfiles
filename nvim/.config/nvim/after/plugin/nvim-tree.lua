local api = require "nvim-tree.api"

local function my_on_attach(bufnr)
    -- default mappings
    api.config.mappings.default_on_attach(bufnr)
    -- custom mappings
    vim.keymap.set("n", "T", api.tree.toggle)
end
vim.keymap.set("n", "T", api.tree.toggle)

-- pass to setup along with your other options
require("nvim-tree").setup {
    on_attach = my_on_attach,
    actions = {
        open_file = {
            quit_on_open = true,
        }
    },
    view = {
        -- signcolumn = "no",
        -- Fullscreen
        -- width = 100000,
    },
    filters = {
        dotfiles = true,
        custom = {
            -- Lock files
            "*.lock",
            -- Object files and the like
            "*.o", "*.so", "*.hi",
            -- Binaries/executables
            function(path)
                return vim.fn.executable(path) == 1
            end,
        },
    },
}
