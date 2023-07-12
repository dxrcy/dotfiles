-- Leader space
vim.g.mapleader = " "
-- Open file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Save file
vim.keymap.set("n", "<C-s>", vim.cmd.write)

-- Enable autocompiler
vim.keymap.set("n", "<C-y>", ":!setsid autocomp % &<CR>", { silent = true })

-- Move selection up/down in visual mode
vim.keymap.set("v", "<leader>j", ":m '>+1<CR>gv=gv'")
vim.keymap.set("v", "<leader>k", ":m '<-2<CR>gv=gv'")

