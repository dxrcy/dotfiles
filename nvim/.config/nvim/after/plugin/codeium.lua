-- Disable default bindings
-- Stops <Tab> being always active
vim.g.codeium_disable_bindings = 1

-- Accept completion
vim.keymap.set("i", "<C-g>", function() return vim.fn["codeium#Accept"]() end, { expr = true, silent = true })
-- Cancel preview
vim.keymap.set("i", "<C-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true, silent = true })
-- Cycle preview
vim.keymap.set("i", "<C-j>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true, silent = true })
vim.keymap.set("i", "<C-k>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true, silent = true })

-- Toggle
vim.keymap.set("n", "<leader>ct", function()
    vim.fn["CodeiumToggle"]()
    print("Code completion: " .. vim.fn["codeium#GetStatusString"]())
end)
