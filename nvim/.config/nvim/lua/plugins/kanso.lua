return { -- Colorscheme selection
	"webhooked/kanso.nvim",
	priority = 1000,
	init = function()
		vim.cmd.colorscheme("kanso-zen")
	end,
	opts = {
		transparent = true,
		overrides = function(_)
			return {
				-- Inactive code should be dimmed, not greyed-out like a comment
				DiagnosticUnnecessary = { dim = true },
				["@lsp.type.comment.c"] = { link = "DiagnosticUnnecessary" },
				["@lsp.type.comment.cpp"] = { link = "DiagnosticUnnecessary" },
			}
		end
	},
}
