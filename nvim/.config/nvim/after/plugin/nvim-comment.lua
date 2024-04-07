require("nvim_comment").setup {
    marker_padding = true,
    comment_empty = true,
    comment_empty_trim_whitespace = true,
    create_mappings = false, -- manual keymaps

    hook = function()
        if vim.api.nvim_buf_get_option(0, "filetype") == "gleam" then
            vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
        elseif vim.api.nvim_buf_get_option(0, "filetype") == "asmish" then
            vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
        end
    end
}

vim.keymap.set("n", "<C-_>", ":CommentToggle<CR>")
vim.keymap.set("i", "<C-_>", "<Esc>:CommentToggle<CR>a")
vim.keymap.set("v", "<C-_>", ":'<,'>CommentToggle<CR>gv")
