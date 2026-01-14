return { -- Manage files in a tree
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",

    keys = {
        { "\\", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
    },

    opts = {
        filesystem = {
            -- Open neotree where netrw would be
            -- For `init` function below
            hijack_netrw_behavior = "open_current",

            follow_current_file   = {
                enabled = true,
            },

            window = {
                mappings = {
                    ["\\"] = "close_window",
                    ["/"] = "none",
                },
            },
        },

        event_handlers = {
            {
                event = "file_opened",
                handler = function()
                    require("neo-tree").close_all()
                end,
            },
        },

        -- Disable extra column (normally shown when neotree is fullscreen)
        default_component_configs = {
            file_size = { enabled = false },
            type = { enabled = false },
            last_modified = { enabled = false },
            created = { enabled = false },
        },

        -- Sort directories and files together
        sort_function = function(a, b)
            return a.path < b.path
        end
    },

    -- If directory is open (eg. `nvim .`), run neotree in current buffer (fullscreen not panel)
    -- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1247#issuecomment-1836294271
    -- This is so that `:q` will close neovim if no buffers were opened
    init = function()
        vim.api.nvim_create_autocmd('BufEnter', {
            -- make a group to be able to delete it later
            group = vim.api.nvim_create_augroup('NeoTreeInit', { clear = true }),
            callback = function()
                local f = vim.fn.expand('%:p')
                if vim.fn.isdirectory(f) ~= 0 then
                    vim.cmd('Neotree current dir=' .. f)
                    -- neo-tree is loaded now, delete the init autocmd
                    vim.api.nvim_clear_autocmds { group = 'NeoTreeInit' }
                end
            end
        })
    end,
}
