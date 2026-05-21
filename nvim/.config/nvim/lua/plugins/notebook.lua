return {
    "twhlynch/notebook.nvim",

    opts = {
        keybind_prefix = "<leader>c",
        max_output_lines = 6,
        custom_plot_theme = true,
        custom_theme_colors = {
            "#4878CF", "#6ACC65", "#D65F5F",
            "#B47CC7", "#C4AD66", "#77BEDB",
        },
        cell_gap = 0,
        write_output = true,
        new_cell_cmd = "normal! A\nstartinsert!",

        keys = {
            run_cell           = "r",
            run_cells_all      = "a",
            run_cells_up       = "u",
            run_cells_down     = "d",
            run_then_next      = "c",

            next_cell          = "]c",
            previous_cell      = "[c",
            textobject_cell    = "ic",

            insert_markdown    = "m",
            insert_code        = "n",
            output_to_md       = "im",
            output_to_md_all   = "ia",
            split_cell         = "s",
            remove_cell        = "X",
            move_cell_up       = "k",
            move_cell_down     = "j",

            clear_all_output   = "x",
            refresh_all_output = "R",
            format_cell        = "f",
            toggle_cell_type   = "S",
            kill_kernel        = "K",
            go_to_running_cell = "g",

            open_image         = "gx",
            show_output        = "<CR>",
            -- dump_images        = "D",
        },

        hl = {
            output  = "NonText",
            error   = "DiagnosticError",
            hint    = "DiagnosticHint",
            success = "DiagnosticOk",
        },

        strings = {
            new_cell         = { "# " },
            new_code_cell    = { "" },

            output_border    = " ┃    ",
            cell_border      = "─",
            code_label       = "  ",
            markdown_label   = "  ",
            output_label     = "  ",

            cell_executed    = "  ",
            cell_running     = " Loading ",
            cell_pending     = " Pending...",
            truncated_output = "%s more lines",
            image_output     = "  × %s",
        },
    },
}
