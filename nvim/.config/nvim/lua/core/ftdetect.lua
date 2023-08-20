-- justfile : make
vim.cmd("au BufRead,BufNewFile justfile set filetype=make")

-- Phonet files
vim.cmd("au BufRead,BufNewFile phonet set filetype=phonet")
vim.cmd("au BufRead,BufNewFile *.phonet set filetype=phonet")

-- Other filetypes
vim.cmd("au BufRead,BufNewFile *.rzr set filetype=razor")
vim.cmd("au BufRead,BufNewFile *.spell set filetype=spell")

