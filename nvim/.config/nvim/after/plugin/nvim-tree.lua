local api = require "nvim-tree.api"

local function my_on_attach(bufnr)
    -- default mappings
    api.config.mappings.default_on_attach(bufnr)
    -- custom mappings
    vim.keymap.set("n", "T", api.tree.toggle)
end
vim.keymap.set("n", "T", api.tree.toggle)

local function is_elf_binary(path)
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

local function ends_with(str, ending)
    return ending == "" or str:sub(- #ending) == ending
end

-- pass to setup along with your other options
require("nvim-tree").setup {
    log = {
        enable = true,
        types = {
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
        custom = function(path)
            return is_elf_binary(path)
                or ends_with(path, ".lock")
                or ends_with(path, ".hi")
        end

    }
}
