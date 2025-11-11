---@type vim.lsp.Config
return {
    cmd = {
        "ziggy",
        "lsp",
        "--schema",
    },
    filetypes = {
        "ziggy_schema",
    },
    root_markers = {
        "zine.ziggy",
    },
}
