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

-- Read key from stdin, return true unless <Esc>
---@param prompt string
---@return nil
local function prompt_confirm(prompt)
    print(prompt)
    local input = vim.fn.nr2char(vim.fn.getchar())
    if input == "\27" then
        print("Cancelled.")
        return false
    end
    return true
end

-- Make current file an executable shell script
---@return nil
M.chmod_executable = function()
    local confirm = prompt_confirm("Make executable shell script? ")
    if not confirm then
        return
    end

    -- Add shebang if none found
    local first_line = vim.fn.getline(1)
    if first_line == "" or not first_line:match("^#!") then
        vim.fn.append(0, "#!/bin/sh")
        vim.fn.append(1, "")
        vim.fn.append(1, "")
        vim.cmd("norm k")
    end
    -- Save, make executable, and set filetype
    vim.cmd("w")
    vim.cmd("silent !chmod +x %")
    vim.cmd("set filetype=sh")
end

return M
