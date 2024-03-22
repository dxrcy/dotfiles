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
        build = function()
            vim.cmd("TSUpdate")
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
    -- LSP Formatter
    -- Idk if this is needed
    "lukas-reineke/lsp-format.nvim",

    -- Autocompletion in command line
    { "hrsh7th/cmp-cmdline" },

    -- Toggle comments
    "terrortylor/nvim-comment",

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

    -- Save files with sudo
    "lambdalisue/suda.vim",

    -- Command aliases
    -- For Esperanto aliases
    {
        "coot/cmdalias_vim",
        dependencies = { { "coot/CRDispatcher" } },
    },

    -- Git stuff
    {
        "lewis6991/gitsigns.nvim",
        init = function()
            require("gitsigns").setup()
        end,
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        version = "0.1.2",
        dependencies = { { "nvim-lua/plenary.nvim" } },
    },

    -- Show possible key bindings
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require("which-key").setup {
                hidden = { "q" },
                triggers_blacklist = {
                    n = { "q" },
                },
            }
        end,
        opts = {},
    },

    -- Navigation
    {
        "ggandor/leap.nvim",
        init = function()
            require('leap').create_default_mappings()
        end
    },

    -- Fancy command line
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            -- "rcarriga/nvim-notify",
        }
    },

    -- Screenshots
    {
        "michaelrommel/nvim-silicon",
        lazy = true,
        cmd = "Silicon",
        config = function()
            require("silicon").setup({
                -- Configuration here, or leave empty to use defaults
                font = "Source Code Pro=34;Noto Color Emoji=34"
            })
        end
    },

    -- Code completion
    { "Exafunction/codeium.vim" },
}

local opts = {}
return require("lazy").setup(plugins, opts)
