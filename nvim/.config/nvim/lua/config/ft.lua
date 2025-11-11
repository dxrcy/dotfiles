---@param filetype string
---@param callback function
---@return nil
local function ft_config(filetype, callback)
    vim.api.nvim_create_autocmd("FileType", {
        pattern = filetype,
        callback = callback
    })
end

ft_config("tex", function()
    vim.bo.indentexpr = ""
end)

ft_config("superhtml", function()
    vim.opt.commentstring = "<!-- %s -->"
end)

local textwidths = {
    c = 80,
    cpp = 100,
    zig = 80,
    rust = 100,
    lua = 80,
    sh = 80,
    zsh = 80,
    bash = 80,
    tex = 80,
}

for filetype, textwidth in pairs(textwidths) do
    ft_config(filetype, function()
        vim.bo.textwidth = textwidth
        vim.opt.colorcolumn = tostring(textwidth)
    end)
end
