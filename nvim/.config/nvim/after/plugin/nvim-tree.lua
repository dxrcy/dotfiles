-- disable netrw at the very start of your init.lua
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
-- vim.opt.termguicolors = true

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
            -- Hide object files and the like
            "*.o", "*.so", "*.hi",
            -- Hide lock files
            "*.lock",
        },
    },
}
