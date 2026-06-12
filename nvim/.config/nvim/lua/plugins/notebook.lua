return {
	"twhlynch/notebook.nvim",
	branch = "feat/py-file-notebooks",

	opts = {
		keybind_prefix = "<leader>c",
		max_output_lines = 6,
		custom_plot_theme = true,
		custom_theme_colors = {
			"#4878CF",
			"#6ACC65",
			"#D65F5F",
			"#B47CC7",
			"#C4AD66",
			"#77BEDB",
		},
		cell_gap = 0,
		write_output = true,
		new_cell_cmd = "normal! A\nstartinsert!",

		keys = {
			run_cell = "r",
			run_cells_all = "a",
			run_cells_up = "u",
			run_cells_down = "d",
			run_then_next = "c",

			next_cell = "]c",
			previous_cell = "[c",
			textobject_cell = "ic",

			insert_markdown = "m",
			insert_code = "n",
			output_to_md = "im",
			output_to_md_all = "ia",
			split_cell = "s",
			remove_cell = "X",
			move_cell_up = "k",
			move_cell_down = "j",

			clear_all_output = "x",
			refresh_all_output = "R",
			format_cell = "f",
			toggle_cell_type = "S",
			kill_kernel = "K",
			go_to_running_cell = "g",

			open_image = "gx",
			show_output = "<CR>",
			-- dump_images        = "D",
		},

		hl = {
			output = "NonText",
			error = "DiagnosticError",
			hint = "DiagnosticHint",
			success = "DiagnosticOk",
		},

		strings = {
			new_cell = { "# " },
			new_code_cell = { "" },

			output_border = " ┃    ",
			cell_border = "─",
			code_label = "  ",
			markdown_label = "  ",
			output_label = "  ",

			cell_executed = "  ",
			cell_running = " Loading ",
			cell_pending = " Pending...",
			truncated_output = "%s more lines",
			image_output = "  × %s",
		},
	},

	init = function()
		vim.keymap.set("n", "<leader>cE", function()
			local py_name = vim.api.nvim_buf_get_name(0)
			local ipynb_name = py_name:gsub("%.nb%.py$", ".ipynb")
			if ipynb_name == py_name then
				return
			end

			local py_buf = vim.api.nvim_get_current_buf()
			local lines = vim.api.nvim_buf_get_lines(py_buf, 0, -1, false)

			local fd = assert(vim.uv.fs_open(ipynb_name, "w", 420))
			vim.uv.fs_close(fd)

			vim.cmd("edit " .. vim.fn.fnameescape(ipynb_name))

			local ipynb_buf = vim.api.nvim_get_current_buf()
			vim.api.nvim_buf_set_lines(ipynb_buf, 0, -1, false, lines)
			vim.api.nvim_buf_call(ipynb_buf, function()
				vim.cmd("write")
			end)
		end, { desc = "Save as ipynb" })
	end,
}
