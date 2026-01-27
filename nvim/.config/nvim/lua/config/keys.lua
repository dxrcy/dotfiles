local commands = require("config.commands")

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Esperanto keys
vim.api.nvim_set_option('langmap', 'ĉx,ĝw,ĥ],ĵ[,ŝq,ŭy,ĈX,ĜW,Ĥ},Ĵ{,ŜQ,ŬY')
-- Manual Esperanto keybinds (for some reason)
vim.keymap.set("n", "cĝ", "cw")
vim.keymap.set("n", "dĝ", "dw")
-- For Esperanto keyboard, or uppercase misspellings
vim.cmd([[cabbrev W w]]) -- w
vim.cmd([[cabbrev ĝ w]])
vim.cmd([[cabbrev Ĝ w]])
vim.cmd([[cabbrev Q q]]) -- q (also covers q!)
vim.cmd([[cabbrev ŝ q]])
vim.cmd([[cabbrev Ŝ q]])
vim.cmd([[cabbrev ĝŝ wq]]) -- wq
vim.cmd([[cabbrev ĜŜ wq]])
vim.cmd([[cabbrev ĝŜ wq]])
vim.cmd([[cabbrev Ĝŝ wq]])
vim.cmd([[cabbrev Wq wq]])
vim.cmd([[cabbrev WQ wq]])
vim.cmd([[cabbrev wQ wq]])

-- Save file
vim.keymap.set("n", "<C-s>", vim.cmd.write, { desc = "Save file" })
vim.keymap.set("i", "<C-s>", vim.cmd.write, { desc = "Save file" })

-- Comment line
vim.keymap.set("n", "<C-/>", "gcc", { desc = "Toggle comment", remap = true })
vim.keymap.set("v", "<C-/>", "gc", { desc = "Toggle comment", remap = true })
-- (Tmux is weird)
vim.keymap.set("n", "<C-_>", "gcc", { desc = "Toggle comment", remap = true })
vim.keymap.set("v", "<C-_>", "gc", { desc = "Toggle comment", remap = true })

-- Override paste without copying deleted text
vim.keymap.set("v", "p", "P")

-- Concatenate lines without adding whitespace
vim.keymap.set("n", "<M-J>", "gJ")

-- Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Stay in visual mode while changing indentation
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "=", "=gv")

-- Window navigation shorthand
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Prevent accidently yanking/deleting lines above/below
vim.keymap.set("n", "yj", "j")
vim.keymap.set("n", "yk", "k")
vim.keymap.set("n", "dj", "j")
vim.keymap.set("n", "dk", "k")

-- Diagnostic float
vim.keymap.set("n", "ge", vim.diagnostic.open_float)
vim.keymap.set("n", "gn", vim.diagnostic.goto_next)
vim.keymap.set("n", "gp", vim.diagnostic.goto_prev)

vim.keymap.set("n", "<leader>v", "ggVG", { desc = "Select entire buffer" })

vim.keymap.set("n", "<leader>q", [[<cmd>.!qalc -t $(cat)<CR>]],
    { desc = "Evaluate line with libqalculate" })

vim.keymap.set("n", "<leader>l", commands.cycle_column_limit,
    { desc = "Change line width / column limit" })

vim.keymap.set("n", "<leader>ex", commands.chmod_executable,
    { desc = "Make current file an executable script" })
