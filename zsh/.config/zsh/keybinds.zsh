#!/bin/zsh

# TODO: Move these functions to other files

# Use narrow cursor for insert mode, block cursor for normal mode
zle-keymap-select() {
    if [ "$KEYMAP" = "vicmd" ]
        then echo -ne "\e[1 q"
        else echo -ne "\e[5 q"
    fi
}; zle -N zle-keymap-select

# Continue background job with keybind
# Only works for 1 job at a time :-)
fg-keybind() {
    # Must use a temp file for `jobs` because it doesn't use a std stream
    # Can be non-unique, bc read immediately after write
    tmp='/tmp/jobs'

    jobs > "$tmp"
    job_count_prev="$(wc -l < "$tmp")"
    # Get number of LAST job CREATED
    job_no="$(tail "$tmp" -n1 | sed 's/^\[\(.*\)\].*/\1/')"

     # No jobs running
    [ -n "$job_no" ] || return 1

    # printf '\033[1A' # Move cursor up
    # printf '\033[1G\033[2K' # Erase line

    # Continue process
    fg "%$job_no"
    # Job not found (shouldn't happen)
    if [ $? -eq 127 ]; then
        return 1
    fi

    jobs > "$tmp"
    job_count_new="$(wc -l < "$tmp")"

    # If same amount of jobs are still running
    # i.e. Job was not killed
    if [ "$job_count_new" -ge "$job_count_prev" ]; then
        # Move cursor up 4 rows
        printf '\033[4A'
    fi

    # Reset prompt
    echo
    zle reset-prompt
}; zle -N fg-keybind

# Zoxide keybind
zoxide-keybind() {
    eval z
    zle reset-prompt
}; zle -N zoxide-keybind

# Yank to the system clipboard
# TODO: Wayland
function vi-yank-xclip {
    zle vi-yank
    echo "$CUTBUFFER" | wl-copy
}; zle -N vi-yank-xclip


# Narrow cursor on new prompt
precmd() {
    echo -ne "\e[5 q"
}

#-------------------------------------------------------------------------------

# Vi mode (best mode)
bindkey -v

# Remove timeout for <Esc>
export KEYTIMEOUT=1

# Fix backspace
bindkey -v '^?' backward-delete-char

# Add missing vim keybinds
bindkey -s -M vicmd '\_' '^'
bindkey -M vicmd 'y' vi-yank-xclip

# Shift-tab to cycle backwards in completion
bindkey "^[[Z" reverse-menu-complete

# Remap Esperanto keys
bindkey -M vicmd -s 'ŝ' 'q'
bindkey -M vicmd -s 'ĝ' 'w'
bindkey -M vicmd -s 'ŭ' 'y'
bindkey -M vicmd -s 'ĵ' '['
bindkey -M vicmd -s 'ĥ' ']'
bindkey -M vicmd -s 'ĉ' 'x'

# Disable Ctrl+D
bindkey -s '^D' ''

# Custom function keybinds
bindkey '^Z' fg-keybind

