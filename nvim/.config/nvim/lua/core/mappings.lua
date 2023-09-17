-- Leader space
vim.g.mapleader = " "
-- Open file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Save file
vim.keymap.set("n", "<C-s>", vim.cmd.write)
vim.keymap.set("i", "<C-s>", vim.cmd.write)

-- Switch to previous buffer
vim.keymap.set("n", "tt", "<cmd>b#<CR>");

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

-- Tree-sitter
vim.keymap.set("n", "<leader>tu", "<cmd>TSUpdate<CR>")
vim.keymap.set("n", "<leader>tp", "<cmd>TSPlaygroundToggle<CR>")
vim.keymap.set("n", "<leader>th", "<cmd>TSHighlightCapturesUnderCursor<CR>")

-- Toggle wrap
vim.keymap.set("n", "<leader>z", function ()
    if vim.wo.wrap then
        vim.wo.wrap = false
        print("Line wrapping is OFF")
    else
        vim.wo.wrap = true
        print("Line wrapping is ON")
    end
end)

-- Stop highlighting searched text
vim.keymap.set('n', '<Esc>', ':noh<CR>', { noremap = true, silent = true })

-- Start a new find-replace command without terms
vim.keymap.set("n", '?', ':%s/')

