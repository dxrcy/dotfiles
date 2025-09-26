-- opts
-------------------

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
    tab = ">·",
    trail = "~",
    nbsp = "␣",
    extends = ">",
    precedes = "<",
}

-- keys
-------------------

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Save file
vim.keymap.set("n", "<C-s>", vim.cmd.write, { desc = "Save file" })
vim.keymap.set("i", "<C-s>", vim.cmd.write, { desc = "Save file" })

-- Comment line
vim.keymap.set("n", "<C-_>", "gcc", { desc = "Toggle comment", remap = true })
vim.keymap.set("v", "<C-_>", "gc", { desc = "Toggle comment", remap = true })

-- Override paste without copying deleted text
vim.keymap.set("v", "p", "P")

-- Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- lazy
-------------------

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        error("Error cloning lazy.nvim:\n" .. out)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
    change_detection = {
        notify = false,
    },
})

-- lsp
-------------------

vim.lsp.enable({
    "clang"
})
