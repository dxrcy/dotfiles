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

ft_config("typst", function()
    vim.bo.shiftwidth = 4
end)

ft_config("lc3", function()
    vim.bo.commentstring = "; %s"
end)

ft_config("python", function()
    vim.diagnostic.enable(false)
end)

local textwidths = {
    c = 80,
    cpp = 100,
    zig = 100,
    rust = 100,
    lua = 80,
    sh = 80,
    zsh = 80,
    bash = 80,
    tex = 80,
    md = 80,
    typst = 80,
    nu = 80,
    python = 80,
}

for filetype, textwidth in pairs(textwidths) do
    ft_config(filetype, function()
        vim.bo.textwidth = textwidth
        vim.opt.colorcolumn = tostring(textwidth)
    end)
end
