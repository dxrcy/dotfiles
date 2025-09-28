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
    vim.bo.textwidth = 80
    vim.opt.colorcolumn = "80"
    vim.bo.indentexpr = ""
end)
