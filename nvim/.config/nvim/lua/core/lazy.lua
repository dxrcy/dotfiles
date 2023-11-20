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
print(lazypath)

local plugins = {
    {
        "nvim-telescope/telescope.nvim", 
        version = "0.1.2",
        dependencies = { { "nvim-lua/plenary.nvim" } },
    },

    {
        "rose-pine/neovim",
        name = "rose-pine"
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        -- build = function ()
        --     -- vim.cmd("TSUpdate") 
        -- end,
    },
    "nvim-treesitter/playground",

    -- File navigation
    -- use("theprimeagen/harpoon")

    -- Undo history
    "mbbill/undotree",

    -- Git
    "tpope/vim-fugitive",

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

    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
        end
    },

    -- Autoclose brackets and quotes
    -- Not working ???
    -- "m4xshen/autoclose.nvim"

    -- Statusline
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

    "lukas-reineke/lsp-format.nvim",

    -- Save files with sudo
    "lambdalisue/suda.vim",

    -- Neorg
    {
        "nvim-neorg/neorg",
        -- config = function()
        --     require('neorg').setup {
        --         load = {
        --             ["core.defaults"] = {}, -- Loads default behaviour
        --             ["core.concealer"] = {}, -- Adds pretty icons to your documents
        --             ["core.dirman"] = { -- Manages Neorg workspaces
        --                 config = {
        --                     workspaces = {
        --                         notes = "~/docs/notes",
        --                     },
        --                 },
        --             },
        --         },
        --     }
        -- end,
        build = ":Neorg sync-parsers",
        dependencies = "nvim-lua/plenary.nvim",
    },
}

local opts = {}

return require("lazy").setup(plugins, opts)

