require("core.mappings")
require("core.lazy")
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

-- Minimum lines to show ahead while scrolling
vim.opt.scrolloff = 8

-- Disable 'Warning: changing a readonly file'
-- See also: save_file in mappings.lua
vim.cmd "au BufEnter * set noro"
vim.cmd "au BufWritePost * set noro"
