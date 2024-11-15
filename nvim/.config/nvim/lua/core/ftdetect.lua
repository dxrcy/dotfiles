-- justfile : make
vim.cmd("au BufRead,BufNewFile justfile set filetype=make")

-- sxhkdrc
vim.cmd("au BufRead,BufNewFile sxhkdrc   set filetype=sxhkdrc")

-- Phonet files
vim.cmd("au BufRead,BufNewFile phonet   set filetype=phonet")
vim.cmd("au BufRead,BufNewFile *.phonet set filetype=phonet")

-- Transcript files
vim.cmd("au BufRead,BufNewFile transcript* set filetype=transcript")

-- Other filetypes
vim.cmd("au BufRead,BufNewFile *.asi   set filetype=asmish")
vim.cmd("au BufRead,BufNewFile *.lur   set filetype=lure")
vim.cmd("au BufRead,BufNewFile *.sca   set filetype=scasm")
