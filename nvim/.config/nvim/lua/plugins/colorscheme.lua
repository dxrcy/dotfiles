return {
	{ -- Colorscheme selection
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		"webhooked/kanso.nvim",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		init = function()
			vim.cmd.colorscheme("kanso-zen")
		end,
	},
}
