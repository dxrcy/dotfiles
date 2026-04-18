---@type vim.lsp.Config
return {
    cmd = {
        "tinymist",
    },
    filetypes = {
        "typst",
    },
    settings = {
        formatterMode = "disable",
        exportPdf = "onSave",
    },
}
