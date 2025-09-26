-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Respect indentation when wrapping line
vim.opt.breakindent = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Always show left column
vim.opt.signcolumn = "yes"

-- Highlight cursor line
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 8

-- Save undo history
vim.opt.undofile = true

-- Disable file backup
vim.opt.swapfile = false
vim.opt.backup = false

-- Use system clipboard
-- Defer to reduce startup time
vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Preview substitutions live
vim.opt.inccommand = "split"

-- Render whitespace characters
vim.opt.list = true
vim.opt.listchars = {
    tab = "▏ ",
    trail = "~",
    nbsp = "␣",
    extends = ">",
    precedes = "<",
}
