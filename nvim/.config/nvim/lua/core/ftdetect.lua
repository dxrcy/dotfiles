-- justfile : make
vim.cmd("au BufRead,BufNewFile justfile set filetype=make")

-- Gleam
-- Tabspace = 2
vim.cmd("au BufRead,BufNewFile *.gleam set tabstop=2")
vim.cmd("au BufRead,BufNewFile *.gleam set softtabstop=2")
vim.cmd("au BufRead,BufNewFile *.gleam set shiftwidth=2")

-- Phonet files
vim.cmd("au BufRead,BufNewFile phonet set filetype=phonet")
vim.cmd("au BufRead,BufNewFile *.phonet set filetype=phonet")

-- Transcript files
vim.cmd("au BufRead,BufNewFile transcript set filetype=transcript")
vim.cmd("au BufRead,BufNewFile garf-transcript-* set filetype=transcript")

-- Other filetypes
vim.cmd("au BufRead,BufNewFile *.rzr set filetype=razor")
vim.cmd("au BufRead,BufNewFile *.spell set filetype=spell")
