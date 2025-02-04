require("nvim_comment").setup {
    marker_padding = true,
    comment_empty = true,
    comment_empty_trim_whitespace = true,
    create_mappings = false, -- manual keymaps

    hook = function()
        local filetype = vim.api.nvim_buf_get_option(0, "filetype")
        local comment = nil
        if filetype == "gleam" then
            comment = "// %s"
        elseif filetype == "sxhkdrc" then
            comment = "# %s"
        elseif filetype == "asmish" then
            comment = "# %s"
        elseif filetype == "lispthing" then
            comment = "(# %s #)"
        elseif filetype == "lure" then
            comment = "# %s"
        elseif filetype == "scasm" then
            comment = "; %s"
        end
        if comment ~= nil then
            vim.api.nvim_buf_set_option(0, "commentstring", comment)
        end
    end
}

vim.keymap.set("n", "<C-_>", ":CommentToggle<CR>")
vim.keymap.set("i", "<C-_>", "<Esc>:CommentToggle<CR>a")
vim.keymap.set("v", "<C-_>", ":'<,'>CommentToggle<CR>gv")
