-- Leader space
vim.g.mapleader = " "
-- Open file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Save file
vim.keymap.set("n", "<C-s>", vim.cmd.write)
vim.keymap.set("i", "<C-s>", vim.cmd.write)

-- Enable autocompiler
-- vim.keymap.set("n", "<C-y>", ":!setsid autocomp % &<CR>", { silent = true })

-- Move selection up/down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Preserve cursor position when merging lines
vim.keymap.set("n", "J", "mzJ`z")

-- Override paste without copying deleted text
-- ??? Same as Shift+P ???
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Disable Shift+Q
vim.keymap.set("n", "Q", "<nop>")

-- Switch tmux projects
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Format
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end)

-- Quickfix ???
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Select all
vim.keymap.set("n", "<C-g>", "ggVG")

