-- justfile : make
vim.cmd("au BufRead,BufNewFile justfile set filetype=make")

-- Disable autocomplete for certain languages
-- vim.cmd("au BufRead,BufNewFile *.java CodeiumDisable")
-- vim.cmd("au BufRead,BufNewFile *.cpp  CodeiumDisable")

-- Phonet files
vim.cmd("au BufRead,BufNewFile phonet   set filetype=phonet")
vim.cmd("au BufRead,BufNewFile *.phonet set filetype=phonet")

-- Transcript files
vim.cmd("au BufRead,BufNewFile transcript        set filetype=transcript")
vim.cmd("au BufRead,BufNewFile garf-transcript-* set filetype=transcript")

-- Other filetypes
vim.cmd("au BufRead,BufNewFile *.rzr   set filetype=razor")
vim.cmd("au BufRead,BufNewFile *.spell set filetype=spell")
vim.cmd("au BufRead,BufNewFile *.asi   set filetype=asmish")
vim.cmd("au BufRead,BufNewFile *.lur   set filetype=lure")
