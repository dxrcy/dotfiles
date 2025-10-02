#!/bin/zsh

# TODO: Move most of this stuff to other files

# Ask to run desktop (display server or compositor specified by `$DESKTOP`)
# Run after all files are sourced
zsh-start-desktop() {
    [ -z "$DISPLAY" ] || [ "$TTY" = "$DESKTOP_TTY" ] || return
    printf '\n\x1b[1mStart desktop? \x1b[0m'
    read -r _ # ^C returns
    export ZSHLVL=0
    hyprland # From `variables.zsh`
}

# Add scripts and binaries to path
# Does not change order if dir is already in PATH
zsh-prepend-path() {
    local dir="$1"
    [ -d "$dir" ] || return 1
    case "$PATH" in
        "$dir")     ;;  # Only item
        "$dir:"*)   ;;  # At start
        *":$dir")   ;;  # At end
        *":$dir:"*) ;;  # In middle
        *) PATH="$dir:$PATH" ;;
    esac
}
zsh-prepend-path "$HOME/scripts/cmd"
zsh-prepend-path "$HOME/.local/bin"

# Change directory by typing name
setopt AUTOCD

# Override AUTOCD for `~/code`
code() {
    if [ "$PWD" = "$HOME" ];
        then cd 'code'
        else command code -r "$@"
    fi
}

# Persistant history
export HISTFILE=$XDG_CACHE_HOME/zsh_history
export HISTSIZE=5000
export SAVEHIST=5000
setopt SHARE_HISTORY        # Share history between terminals
setopt HIST_IGNORE_ALL_DUPS # Sequential duplicates are squashed
# TODO: Fix this option not working
setopt HIST_IGNORE_SPACE    # Don't save commands that start with space

# Set $EDITOR for local vs remote session
if [ -n "$SSH_CONNECTION" ];
    then export EDITOR='vim'
    else export EDITOR='nvim'
fi

# Auto aliases
eval "$(zoxide init zsh)"

# Don't call `compinit` for every shell
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
    compinit
done
compinit -C

# See also: zsh-history-substring-search plugin
# Use case-insensitive autocompletions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Disable command-specific tab completions
# Only list commands and files
zstyle ':completion:*' completer _files _command_names

# Use neovim as man pager
export MANPAGER='nvim +Man!'

# TODO: Fix
# Shell nesting
if [ -z "$ZSHLVL" ]; then
    ZSHLVL=1
elif [ -n "$ZSHLVL_NOINC" ]; then
    [ "$ZSHLVL_NOINC" = 'all' ] || unset ZSHLVL_NOINC
else
    ZSHLVL=$((ZSHLVL + 1))
fi
export ZSHLVL

