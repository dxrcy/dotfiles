-- Shorthands for this file
-- local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

-- Leader space
vim.g.mapleader = " "

-- Esperanto keys
vim.api.nvim_set_option('langmap', 'ĉx,ĝw,ĥ],ĵ[,ŝq,ŭy,ĈX,ĜW,Ĥ},Ĵ{,ŜQ,ŬY')
-- Manual Esperanto keybinds (for some reason)
keymap("n", "cĝ", "cw")

-- Save file
-- Show nice error if file is readonly
local function is_file_writable()
    local current_file = vim.fn.bufname(vim.fn.bufnr('%'))
    -- returns `0` if file DOESNT exist, OR is writable by user
    local writable = vim.fn.system("! test -f " .. current_file .. " || test -w " .. current_file .. " ; echo $?")
    return string.sub(writable, 1, 1) == '0'
end
local function save_file()
    if is_file_writable() then
        vim.cmd.write()
    else
        vim.cmd "echohl ErrorMsg"
        vim.cmd "echom 'File is readonly'"
        vim.cmd "echohl None"
    end
end
keymap("n", "<C-s>", save_file)
keymap("i", "<C-s>", save_file)

-- Navigate buffers
-- See also: telescope.lua
keymap("n", "tn", "<cmd>bnext<CR>");
keymap("n", "tp", "<cmd>bprevious<CR>");
-- Flip between 2 most recent buffers
keymap("n", "tt", "<cmd>b#<CR>");

-- Move selection up/down in visual mode
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

-- Preserve cursor position when merging lines
keymap("n", "J", "mzJ`z")

-- Override paste without copying deleted text
keymap("v", "p", '"_dP')
-- keymap("v", "<leader>p", 'p')

-- Disable Shift+Q
keymap("n", "Q", "<nop>")

-- Format
keymap("n", "<leader>lf", function()
    vim.lsp.buf.format()
end)

-- Select all
keymap("n", "<leader>vv", "ggVG")

-- Tree-sitter
keymap("n", "<leader>tu", "<cmd>TSUpdate<CR>")
keymap("n", "<leader>tp", "<cmd>TSPlaygroundToggle<CR>")
keymap("n", "<leader>th", "<cmd>TSHighlightCapturesUnderCursor<CR>")

-- Toggle wrap
keymap("n", "<leader>z", function()
    if vim.wo.wrap then
        vim.wo.wrap = false
        print("Line wrapping is OFF")
    else
        vim.wo.wrap = true
        print("Line wrapping is ON")
    end
end)

-- Stop highlighting searched text
keymap('n', '<Esc>', ':noh<CR>')

-- Start a new find-replace command without terms
keymap("n", '?', ':%s/')

-- Read key from stdin, return true unless <Esc>
local function prompt_confirm(prompt)
    print(prompt)
    local input = vim.fn.nr2char(vim.fn.getchar())
    if input == "\27" then
        print("Cancelled.")
        return false
    end
    return true
end

-- Make current file an executable shell script
keymap("n", "<leader>ex", function()
    local confirm = prompt_confirm("Make executable shell script? ")
    if not confirm then
        return
    end

    -- Add shebang if none found
    local first_line = vim.fn.getline(1)
    if first_line == "" or not first_line:match("^#!") then
        vim.fn.append(0, "#!/bin/sh")
        vim.fn.append(1, "")
        vim.fn.append(1, "")
        vim.cmd("norm k")
    end
    -- Save, make executable, and set filetype
    vim.cmd("w")
    vim.cmd("silent !chmod +x %")
    vim.cmd("set filetype=sh")
end, { desc = "what" })

-- Don't of showing in command history, if `:q` is mistyped
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^--- Genious English Skills!
keymap("n", "q:", ":")

-- Window (vim panes) navigation
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

-- Stay in indent mode
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Keep cursor in middle of screen when moving up/down
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "<C-d>", "<C-d>zz")

-- Html boilerplate
keymap("n", "<leader>html",
    [[
i<!DOCTYPE html>
<html lang="en">
<head>
<title>  </title>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="shortcut icon" href="favicon.png">

<link rel="stylesheet" href="style.css">
<script src="main.js"></script>
</head>
<body>

</body>
</html>
<Esc>13kf>la]]
)

-- Disable deleting lines above/below
keymap("n", "dj", "j")
keymap("n", "dk", "k")
