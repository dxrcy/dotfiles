return { -- Git integration for buffers
	"lewis6991/gitsigns.nvim",
	event = "VeryLazy",

	opts = {
		current_line_blame = true,

		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buf = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map("n", "]h", function()
				if vim.wo.diff then
					vim.cmd.normal { "]h", bang = true }
				else
					---@diagnostic disable-next-line: param-type-mismatch
					gitsigns.nav_hunk("next")
				end
			end, { desc = "Next hunk", noremap = true })

			map("n", "[h", function()
				if vim.wo.diff then
					vim.cmd.normal { "[h", bang = true }
				else
					---@diagnostic disable-next-line: param-type-mismatch
					gitsigns.nav_hunk("prev")
				end
			end, { desc = "Previous hunk", noremap = true })

			-- Actions
			map(
				"n",
				"<leader>hs",
				gitsigns.stage_hunk,
				{ desc = "Stage hunk", noremap = true }
			)
			map(
				"n",
				"<leader>hr",
				gitsigns.reset_hunk,
				{ desc = "Reset hunk", noremap = true }
			)

			map("v", "<leader>hs", function()
				gitsigns.stage_hunk { vim.fn.line("."), vim.fn.line("v") }
			end, { desc = "Stage hunk", noremap = true })

			map("v", "<leader>hr", function()
				gitsigns.reset_hunk { vim.fn.line("."), vim.fn.line("v") }
			end, { desc = "Reset hunk", noremap = true })

			map(
				"n",
				"<leader>hp",
				gitsigns.preview_hunk_inline,
				{ desc = "Preview hunk inline", noremap = true }
			)

			map({ "n", "v" }, "<leader>ht", function()
				gitsigns.toggle_linehl()
				local state = gitsigns.toggle_numhl()
				print("gitsigns hl: " .. (state and "on" or "off"))
			end, { desc = "Toggle Diff Highlight", noremap = true })
		end,
	},
}
