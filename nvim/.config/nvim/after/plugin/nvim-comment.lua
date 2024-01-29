require("nvim_comment").setup {
    marker_padding = true,
    comment_empty = true,
    comment_empty_trim_whitespace = true,
    create_mappings = false, -- manual keymaps
    hook = nil
}

vim.keymap.set("n", "<C-_>", ":CommentToggle<CR>")
vim.keymap.set("i", "<C-_>", "<Esc>:CommentToggle<CR>a")
vim.keymap.set("v", "<C-_>", ":'<,'>CommentToggle<CR>gv")
