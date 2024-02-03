local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

require("telescope").setup({
    defaults = {
        file_ignore_patterns = {
            -- Build and module directories
            "build", "target", "node_modules",
            -- Lock files
            "*.lock",
            -- Object files and the like
            "*.o", "*.so", "*.hi",
        },
    },
})
