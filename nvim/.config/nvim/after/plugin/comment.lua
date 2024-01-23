local api = require("Comment.api")

-- Comment line
vim.keymap.set("n", "<C-_>", api.toggle.linewise.current)
vim.keymap.set("i", "<C-_>", api.toggle.linewise.current)

-- idk what this does?
local esc = vim.api.nvim_replace_termcodes(
    "<ESC>", true, false, true
)

-- Comment line in visual mode
vim.keymap.set("x", "<C-_>", function()
    vim.api.nvim_feedkeys(esc, "nx", false)
    api.toggle.linewise(vim.fn.visualmode())
end)

