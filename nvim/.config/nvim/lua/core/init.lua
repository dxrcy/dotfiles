require("core.mappings")
require("core.packer")
require("core.ftdetect")

-- Indent
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

-- Don't highlight all searches
-- vim.opt.hlsearch = false

-- Minimum lines to show ahead while scrolling
vim.opt.scrolloff = 8

-- vim.opt.updatetime = 50

