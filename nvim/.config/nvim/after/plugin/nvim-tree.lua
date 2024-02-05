local api = require "nvim-tree.api"

local function my_on_attach(bufnr)
    -- default mappings
    api.config.mappings.default_on_attach(bufnr)
    -- custom mappings
    vim.keymap.set("n", "T", api.tree.toggle)
end
vim.keymap.set("n", "T", api.tree.toggle)

local function is_binary(path)
    -- 4-byte 'magic number' for ELF
    local magic_number = string.char(0x7f) .. "ELF"

    local fd = vim.loop.fs_open(path, "r", 438)
    if not fd then
        return false
    end
    local stat = vim.loop.fs_fstat(fd)
    if not stat then
        return false
    end
    local data = vim.loop.fs_read(fd, 4, 0)
    vim.loop.fs_close(fd)

    return data == magic_number
end

-- pass to setup along with your other options
require("nvim-tree").setup {
    log = {
        enable = true,
        types = {
            all = true,
            dev = true,
        },
    },
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
            -- "*.o", "*.so", "*.hi",
            -- Binaries/executables
            is_binary,
        },
    },
}
