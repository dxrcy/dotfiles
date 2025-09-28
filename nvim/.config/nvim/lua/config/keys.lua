-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Save file
vim.keymap.set("n", "<C-s>", vim.cmd.write, { desc = "Save file" })
vim.keymap.set("i", "<C-s>", vim.cmd.write, { desc = "Save file" })

-- Comment line
vim.keymap.set("n", "<C-_>", "gcc", { desc = "Toggle comment", remap = true })
vim.keymap.set("v", "<C-_>", "gc", { desc = "Toggle comment", remap = true })

-- Override paste without copying deleted text
vim.keymap.set("v", "p", "P")

-- Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Stay in visual mode while changing indentation
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "=", "=gv")

-- Window navigation shorthand
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Prevent accidently yanking/deleting lines above/below
vim.keymap.set("n", "yj", "j")
vim.keymap.set("n", "yk", "k")
vim.keymap.set("n", "dj", "j")
vim.keymap.set("n", "dk", "k")

-- Diagnostic float
vim.keymap.set("n", "ge", vim.diagnostic.open_float)
vim.keymap.set("n", "gn", vim.diagnostic.goto_next)
vim.keymap.set("n", "gp", vim.diagnostic.goto_prev)

-- Cycle column limit
vim.keymap.set("n", "<C-l>", function()
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
end)
