M = {}

---@return nil
M.cycle_column_limit = function()
    ---@param current number|nil
    ---@return number|nil
    local function next_column_limit(current)
        local VALUES = { 80, 100, 120 }
        if current == 0 or current == nil then
            return VALUES[1]
        end
        for i = 1, #VALUES - 1 do
            if current <= VALUES[i] then
                return VALUES[i + 1]
            end
        end
        return nil
    end

    local current = tonumber(vim.opt.colorcolumn:get()[1])
    vim.opt.colorcolumn = tostring(next_column_limit(current) or "")
end

return M
