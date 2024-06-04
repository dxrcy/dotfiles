require("core.mappings")
require("core.lazy")
require("core.ftdetect")

-- Indent
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Use system clipboard
vim.opt.clipboard = "unnamedplus"

-- Backup with undotree
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.local/state/nvim-undodir"
vim.opt.undofile = true

-- Minimum lines to show ahead while scrolling
vim.opt.scrolloff = 8

-- Disable 'Warning: changing a readonly file'
-- See also: save_file in mappings.lua
vim.cmd "au BufEnter * set noro"
vim.cmd "au BufWritePost * set noro"

vim.system({"git-autofetch"})

