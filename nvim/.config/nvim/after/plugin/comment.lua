local api = require("Comment.api")

-- Comment line in normal mode
vim.keymap.set("n", "<C-_>", api.toggle.linewise.current)

-- Comment line in insert mode
vim.keymap.set("i", "<C-_>", function()
    api.toggle.linewise.current()
end)

-- idk?
local esc = vim.api.nvim_replace_termcodes(
    "<ESC>", true, false, true
)

-- Comment line in visual mode
vim.keymap.set("x", "<C-_>", function()
    vim.api.nvim_feedkeys(esc, "nx", false)
    api.toggle.linewise(vim.fn.visualmode())
end)

