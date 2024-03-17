vim.keymap.set("i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, { expr = true, silent = true })
vim.keymap.set("i", "<C-N>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true, silent = true })
vim.keymap.set("i", "<C-P>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true, silent = true })
vim.keymap.set("i", "<C-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true, silent = true })

vim.keymap.set("n", "<leader>ct", function() return vim.fn["CodeiumToggle"]() end, { expr = true, silent = true })
