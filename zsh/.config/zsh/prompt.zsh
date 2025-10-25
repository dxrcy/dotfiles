#!/bin/zsh

# Misc.
_dot='·'
_gt='❯'

# Display shell nesting level
# Variable, not function (unlike below)
# _arrow=''
# if [ -n "$ZSHLVL" ]; then
#     for _ in $(seq 2 $ZSHLVL); do
#         _arrow="$_arrow="
#     done
# fi
# if [ $_arrow ]; then
#     _arrow="$_arrow> "
# fi

# Prompt substring functions
setopt PROMPT_SUBST # Enable
_colorize() {
    [ $# -eq 3 ] || return 1
    if [ -n "$1" ]; then
        echo "$2$1$3"
    fi
}
git_branch() { _colorize "$(git-info -b)" ' %F{blue}' '' }
git_status() { _colorize "$(git-info)" ' %F{red}[' ']' }
version() { _colorize "$(package-version)" " %F{green}\x1b[2mv" "\x1b[0m" }

# Concat strings for PSx prompt
_prompt() {
    local reset='%b%f%F{white}' # Reset color and formatting
    for arg in $*; do
        _PS="$_PS$arg"
    done
    _PS="$_PS$reset"
}

# Make PS1
PS1_GIT=1
ps1-git() { # Toggle Git information in PS1 (if running slow)
    if [ -n "$PS1_GIT" ];
        then unset PS1_GIT
        else PS1_GIT=1
    fi
    _set_ps1
}

#            BOLD   COLOR           VALUE
_set_ps1() {
    _PS=''
    _prompt "$(printf "\033[?25h")" # Always show cursor
    _prompt         "%F{cyan}"      "$_arrow"       # Shell nesting level
    _prompt  "%B"   "%F{yellow}"    "%3~"           # Last 3 folders of PWD
    if [ -n "$PS1_GIT" ]; then
        _prompt                     '$(git_branch)' # Git: Branch
        _prompt                     '$(git_status)' # Git: Status
    fi
    _prompt                         '$(version)'    # Package version (also dim)
    _prompt         "%F{cyan}"      "%(0?.. $_dot)" # Non-zero exit code = dot
    _prompt                         $'\n'           #
    _prompt         "%F{cyan}"      "%(1j.[%j].)"   # Job count
    _prompt         '%F{yellow}'    "$_gt "         # >
    PS1="$_PS"
}
_set_ps1

