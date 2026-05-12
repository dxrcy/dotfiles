return {
    cmd = {
        "clangd",
        "--clang-tidy",
        "--background-index",
    },
    filetypes = {
        "c",
        "cpp",
        "h",
        "hpp",
        "cc",
    },
    root_markers = {
        ".git",
        "compile_commands.json",
        "compile_flags.txt",
    },
}
