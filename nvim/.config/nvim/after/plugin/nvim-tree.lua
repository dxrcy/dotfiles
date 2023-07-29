-- disable netrw at the very start of your init.lua
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
-- vim.opt.termguicolors = true

-- Inline ???
local function toggle_tree()
    vim.cmd("NvimTreeToggle")
end

local function my_on_attach(bufnr)
    local api = require "nvim-tree.api"

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set("n", "T", toggle_tree)
end

vim.keymap.set("n", "T", toggle_tree)

-- pass to setup along with your other options
require("nvim-tree").setup {
    on_attach = my_on_attach,
    actions = {
        open_file = {
            quit_on_open = true,
        }
    }
}

