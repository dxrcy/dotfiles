for _, source in ipairs {
  "astronvim.bootstrap",
  "astronvim.options",
  "astronvim.lazy",
  "astronvim.autocmds",
  "astronvim.mappings",
} do
  local status_ok, fault = pcall(require, source)
  if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

if astronvim.default_colorscheme then
  if not pcall(vim.cmd.colorscheme, astronvim.default_colorscheme) then
    require("astronvim.utils").notify(
      "Error setting up colorscheme: " .. astronvim.default_colorscheme,
      vim.log.levels.ERROR
    )
  end
end

-- Toggle background transparency with F2
vim.t.is_transparent = 0
function toggle_transparent()
    if vim.t.is_transparent == 0 then
        vim.api.nvim_set_hl(0, "Normal", {guibg = NONE; ctermbg = NONE})
        vim.api.nvim_set_hl(0, "NeoTree", {guibg = NONE; ctermbg = NONE})
        vim.t.is_transparent = 1
    else
        vim.opt.background = "dark"
        vim.t.is_transparent = 0
    end
end
vim.keymap.set("n", "<F2>", toggle_transparent, opts)
toggle_transparent()

-- Treesitter Handlebars highlighting
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.glimmer = {
  install_info = {
    url = "~/.config/nvim/packages/tree-sitter-glimmer",
    files = {
      "src/parser.c",
      "src/scanner.c"
    }
  },
  filetype = "hbs",
  used_by = {
    "handlebars",
    "html.handlebars"
  }
}

vim.opt.tabstop    = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab  = true

require("astronvim.utils").conditional_func(astronvim.user_opts("polish", nil, false), true)
