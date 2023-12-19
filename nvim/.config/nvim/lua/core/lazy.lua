local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    print("Installing Lazy.nvim")
    print("Clone git repository...")
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    -- Rose pine color theme
    {
        "rose-pine/neovim",
        name = "rose-pine"
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = function ()
            -- vim.cmd("TSUpdate") 
        end,
    },
    "nvim-treesitter/playground",

    -- LSP
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        dependencies = {
            -- LSP Support
            { "neovim/nvim-lspconfig" }, -- Required
            {                            -- Optional
                "williamboman/mason.nvim",
                build = function()
                    pcall(vim.cmd, "MasonUpdate")
                end,
            },
            { "williamboman/mason-lspconfig.nvim" }, -- Optional
            -- Autocompletion
            { "hrsh7th/nvim-cmp" },                  -- Required
            { "hrsh7th/cmp-nvim-lsp" },              -- Required
            { "L3MON4D3/LuaSnip" },                  -- Required
            { "hrsh7th/vim-vsnip" },
        }
    },

    -- LSP Rename
    {
        'filipdutescu/renamer.nvim',
        branch = 'master',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },

    -- Toggle comments
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    },

    -- Autoclose brackets/quotes
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
        end
    },

    -- Status line
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true }
    },

    -- Filetree
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- optional
        },
    },

    -- ?
    "lukas-reineke/lsp-format.nvim",

    -- Save files with sudo
    "lambdalisue/suda.vim",

    -- Neorg (markdown-like notes)
    {
        "nvim-neorg/neorg",
        config = function()
            require('neorg').setup {
                load = {
                    ["core.defaults"] = {}, -- Loads default behaviour
                    ["core.concealer"] = {}, -- Adds pretty icons to your documents
                    ["core.dirman"] = { -- Manages Neorg workspaces
                        config = {
                            workspaces = {
                                notes = "~/docs/notes",
                            },
                        },
                    },
                },
            }
        end,
        build = function()
            vim.cmd(":Neorg sync-parsers")
        end,
        dependencies = "nvim-lua/plenary.nvim",
    },

    -- Command aliases
    {
        "coot/cmdalias_vim",
        dependencies = { { "coot/CRDispatcher" } },
    },

    -- Git stuff
    "lewis6991/gitsigns.nvim",

    -----------------------------------
    -- Remove this stuff ? (i dont use)
    
    -- Telescope
    -- {
    --     "nvim-telescope/telescope.nvim", 
    --     version = "0.1.2",
    --     dependencies = { { "nvim-lua/plenary.nvim" } },
    -- },

    -- Git
    -- "tpope/vim-fugitive",

    -- Undo history
    -- "mbbill/undotree",
}

local opts = {}

return require("lazy").setup(plugins, opts)

