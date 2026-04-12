return {
    "twhlynch/nvim-plugins",

    opts = {
        elk = {
            enabled = true,
            binary = "elk",
            debounce = 400,
            filetypes = { "asm", "lc3" },
        },

        notebook = {
            enabled = true,
            keybind_prefix = "<leader>c",
            max_output_lines = 10,
            cell_gap = 1,
            custom_plot_theme = true,
            custom_theme_colors = { "#4878CF", "#6ACC65", "#D65F5F", "#B47CC7", "#C4AD66", "#77BEDB" },
            debug = false,

            keys = {
                run_cell = "r",
                run_cells_all = "a",
                run_cells_up = "u",
                run_cells_down = "d",

                next_cell = "]c",
                previous_cell = "[c",

                insert_markdown = "m",
                insert_code = "c",
                remove_cell = "X",

                clear_all_output = "x",
                refresh_all_output = "R",

                open_image = "gx",
                show_output = "<CR>",

                split_cell = "s",
            },

            hl = {
                output = "NonText",
                error = "DiagnosticError",
                hint = "DiagnosticHint",
                success = "DiagnosticOk",
            },

            strings = {
                new_cell = { "" },
                new_code_cell = { "" },

                output_border = "┃   ",
                cell_border = "─",
                cell_executed = "[ ✓ Done ]",
                cell_running = "[ Running... ]",
                truncated_output = "<Enter> %s more lines",
                image_output = "<gx> %s × image",

                bridge_error = "Jupyter Bridge Error: ",
                install_prompt = "Missing 'jupyter_client'. Install with pip?",
                no_client = "Not running client",
                installing = "Installing jupyter_client...",
                install_success = "Successfully installed",
                install_fail = "Failed to install",
            },
        },
    },
}
