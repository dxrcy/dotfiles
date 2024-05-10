#!/bin/zsh
# -------------------------
# Blazingly fast Zsh config
# -------------------------

#========= MISC
# Vi mode in prompt (best mode)
    bindkey -v
    export KEYTIMEOUT=1                  # Remove timeout for <Esc>
    bindkey -v '^?' backward-delete-char # Fix backspace
    # Use narrow cursor for insert mode, block cursor for normal mode
    zle-keymap-select() {
      [[ $KEYMAP == "vicmd" ]] \
        && echo -ne "\e[1 q" \
        || echo -ne "\e[5 q"
    }; zle -N zle-keymap-select
    precmd() { echo -ne "\e[5 q" } # Narrow cursor on new prompt
    # Add missing vim keybinds
    bindkey -s -M vicmd '\_' '^'
    # Yank to the system clipboard
    function vi-yank-xclip {
        zle vi-yank
        echo "$CUTBUFFER" | xclip -selection clipboard
    }; zle -N vi-yank-xclip
    bindkey -M vicmd 'y' vi-yank-xclip
    bindkey -M vicmd -s 'ŝ' 'q' # Remap Esperanto keys
    bindkey -M vicmd -s 'ĝ' 'w'
    bindkey -M vicmd -s 'ŭ' 'y'
    bindkey -M vicmd -s 'ĵ' '['
    bindkey -M vicmd -s 'ĥ' ']'
    bindkey -M vicmd -s 'ĉ' 'x'
# Open lf
    bindkey -s '^W' 'lf\n'
    bindkey -s -M vicmd '^W' 'ilf\n'
    bindkey -s -M vicmd 'T' 'ilf\n'
# Other keybinds
    bindkey -s '^D' ''      # Disable Ctrl+D
    bindkey -s '^Z' 'fg\n'  # Focus background task
# Change directory by typing name
    setopt AUTOCD
    alias   '...'='cd ../../'
    alias  '....'='cd ../../../'
    alias '.....'='cd ../../../../'
# Undo last `cd` with `dc`
    alias cd='LASTDIR="$(pwd)"; cd'      # Save working directory
    alias dc='_DIR=$LASTDIR; cd "$_DIR"' # Go back to previous directory
    # Make work with `AUTOCD`
    TRAPDEBUG() {
        dir="${ZSH_DEBUG_CMD/#\~/$HOME}"
        # If is a directory, and not a command
        if [ -d "$dir" ] && ! type "$dir" >/dev/null; then
            LASTDIR="$PWD"
        fi
    }
# Add scripts and binaries to path
    PATH="$HOME/scripts/cmd:$PATH"
    PATH="$HOME/.local/bin:$PATH"
# Auto aliases
    eval "$(zoxide init zsh)"
# Preferred editor for local and remote sessions
    [[ -n $SSH_CONNECTION ]] \
        && export EDITOR='vim' \
        || export EDITOR='nvim'
# Override default browser
    BROWSER='librewolf'
# Persistant history
    HISTFILE=~/.cache/zsh_history
    HISTSIZE=2000
    SAVEHIST=2000
    setopt SHARE_HISTORY        # Share history between terminals
    setopt HIST_IGNORE_ALL_DUPS # Duplicate history lines are ignored
    # See also: zsh-history-substring-search plugin
# Use case-insensitive autocompletions
    autoload -Uz compinit && compinit
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Fix zsh tab completion when using `eza` package
    _exa() { eza }
# Fix i3-msg
    unset I3SOCK
# Misc. shorthand variables
    GH='https://github.com' # See also: `gcl`
    GHU="$GH/dxrcy"
# Shell nesting
    [ -z $ZSH ] && ZSH=0 \
        || { [ -z $ZSH_NOINC ] && ZSH=$((ZSH + 1)); }
    export ZSH

#========= IDK!
zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate #enable approximate matches for completion

#========= PROMPT
# Display shell nesting level
    # Variable, not function (unlike below)
    for _ in $(seq 1 $ZSH); do _arrow="$_arrow="; done
    [ $_arrow ] && { _arrow="$_arrow> "; }
# Prompt substring functions
    setopt PROMPT_SUBST # Enable
    git_branch() { x=$(git-info -b);     [ "$x" ] && echo "%F{blue} $x" }
    git_status() { x=$(git-info);        [ "$x" ] && echo "%F{red} [$x]" }
    version()    { x=$(package-version); [ "$x" ] && echo "%F{green}\x1b[2m v$x\x1b[0m" }
# Concat strings for PSx prompt
    _prompt() {
        local reset='%b%f%F{white}' # Reset color and formatting
        for arg in $*; do
            _PS="$_PS$arg"
        done
        _PS="$_PS$reset"
    }
# Make PS1
    _dot='·'
    _gt='❯'
    #        BOLD     COLOR           VALUE
    _PS=''
    _prompt         "%F{cyan}"      "$_arrow"       # Shell nesting level
    _prompt  "%B"   "%F{yellow}"    "%n"            # Username
    _prompt         "%F{green}"     "@"             # @
    _prompt  "%B"   "%F{blue}"      "%m"            # Hostname
    _prompt                         ' '             # 
    _prompt         "%F{magenta}"   "%3~"           # Last 3 folders of PWD
    _prompt                         '$(git_branch)' # Git: Branch
    _prompt                         '$(git_status)' # Git: Status
    _prompt                         '$(version)'    # Package version (also dim)
    _prompt         "%F{cyan}"      "%(0?.. $_dot)" # Non-zero exit code = dot
    _prompt                         $'\n'           #
    _prompt         "%F{cyan}"      "%(1j.[%j].)"   # Job count
    _prompt         '%F{green}'     "$_gt "         # >
    PS1="$_PS"

#========= ALIASES
# Tmux
    alias  t='tmux'
    alias ta='tmux -u attach'
    alias tk='tmux kill-server'
# Exit (vim style)
    alias   q='exit'
    alias  :q='exit'
    alias :wq='exit'
    alias   ŝ='exit'
    alias  :ŝ='exit'
    alias :ĝŝ='exit'
# Git (even tho lazygit is easier)
    alias    g='git'
    alias   gs='git status'
    alias   ga='git add'
    alias   gc='git commit -m'
    alias  gac='git add -A && git commit -m'
    alias  gca='git commit --amend -m'
    alias   gp='git push'
    alias   gd='git diff'
    alias   gl='git log'
    alias   gr='git remote'
    alias grao='git remote add     origin'
    alias grro='git remote remove  origin'
    alias grso='git remote set-url origin'
    alias grgo='git remote get-url origin'
    alias  gcl='git-clone-cd'
    alias  ghu='gh-username'
# Nvim
    # Open folder in nvim, instead of new buffer
    v() { [ "$*" ] && nvim $* || nvim . }
    alias vim='nvim'
# Pacman wrapper script
    alias p='pacman-thing'
# Rust (cargo)
    alias    c='cargo'
    alias   cr='cargo run'
    alias   cb='cargo build'
    alias   cc='cargo check'
    alias   ct='cargo test'
    alias  crr='cargo run --release'
    alias  cbr='cargo build --release'
    alias cdoc='cargo doc --no-deps --open'
    alias   cw='cargo watch -c'
    alias  cwr='cargo watch -x run -c'
    alias  cwc='cargo watch -c'
    alias cwcl='cargo watch -x clippy -c'
    alias  cwt='cargo watch -x test -c'
    alias   ci='cargo install'
    alias  cip='cargo install --path .'
    alias  cex='cargo expand | nvim -Rc "set ft=rust"' # Expand macro, open in nvim
    alias  ccl='cargo clippy'
    alias   cn='cargo-new-cd'
# Common directories
    alias     docs='cd ~/docs'
    alias       dl='cd ~/dl'
    alias     pics='cd ~/pics'
    alias     vids='cd ~/vids'
    alias    music='cd ~/music'
    alias  scripts='cd ~/scripts'
    alias dotfiles='cd ~/dotfiles'
    alias     code='cd ~/code'
    alias s='sandbox-fzf'
# Common dotfile editing
    alias .d='cd ~/dotfiles'
    alias .z='cd ~/dotfiles/zsh                && nvim .zshrc'
    alias .v='cd ~/dotfiles/nvim/.config/nvim  && nvim .'
    alias .t='cd ~/dotfiles/tmux/.config/tmux  && nvim tmux.conf'
    alias .i='cd ~/dotfiles/i3/.config/i3      && nvim config'
# Misc. Programs and options
    alias cat='bat'
    alias ls='eza -l --group-directories-first'
    alias lsa='ls -a'
    alias lst='ls --total-size'
    alias tree='ls -T'
    alias treea='ls -T -a'
    alias find='fd'
    alias mkdir='mkdir -p'
    alias cp='cp -r'
    alias grep="rg"
    alias nsxiv='nsxiv -a'
    alias sxiv='nsxiv'
    alias zig='~/.zvm/bin/zig'
    alias pstree='pstree -U | less'
    alias zhistory='v ~/.cache/zsh_history'
    alias lf='cd "$(\lf -print-last-dir)"' # Use lf to `cd`, without spawning subshell
    alias mkd='mkdir-cd'
    alias eo='garfeo-mode'
    alias ll='cd-last-command'
    alias mpv='mpv --script=~/.config/mpv/mpv-cheatsheet.js'
    alias gcc='gcc -Wall -Wpedantic'
# Misc. Abbreviations / Mispellings
    alias j='just'
    alias a='garf'
    alias o='xdg-open'
    alias ,='abandon' # Script
    alias z='zi'
    alias r='lf'
    alias l='lf'
    alias th='thunar'
    alias lw='librewolf'
    alias clip='xclip -selection clipboard'
    alias sy='systemctl'
    alias syu='systemctl --user'
    alias ping8='ping 8.8.8.8 -c 10'
    alias cal3='cal -3'
    alias doas="echo -e \"\x1b[34mdoas I do:\x1b[0m \x1b[1msudo\x1b[0m\""
    alias zr='unalias -a; ZSH_NOINC=1 source ~/.zshrc'
    alias pk='pkill'
    alias btc='bluetoothctl'
    alias plc='bluetoothctl'
    alias bhs='basic-http-server'
    alias rl='readlink'
    alias pst='ps-tree'
    alias backup='backup-file' # Script
    alias entra='entr-all'
    alias ghs='gh auth switch'
    am() { garf make $* && exit }

#========= LONGER FUNCTIONS (Aliased)
    gh-url() { # Git url shorthand
        url="$1"
        case "$url" in
            '') return 1 ;;
            @*) echo "$GH/${url:1}" ;;
            :*) echo "$GHU/${url:1}" ;;
             *) echo "$url" ;;
         esac
    }
    gh-username() {
        gh auth status | grep --color=never -Po '(?<=Logged in to github.com account )[^\s]*'
    }
    git-clone-cd() { # Git clone alias with URL shorthand, and cd
        url="$(gh-url $1)" || { git clone ; return $?; }
        shift
        git clone "$url" $* || return $?
        target="$1" # Target directory argument, or use URL path
        [ -z "$target" ] && target="${${url##*/}%.git}" 
        cd "$target"
    }
    ghcr() {
        ghc -Wall -dynamic $* >/dev/null || return $?
        ./"${1%%.hs}"
    }
    gccr() {
        out="${1%.c}"
        gcc "$1" -o "$out" || return $?
        ./"$out"
        code="$?"
        [ "$code" = 139 ] && echo "Segfault! lol."
        return "$code"
    }
    entr-all() {
        find | entr -c zsh -i -c "$*"
    }
    cargo-new-cd() {
        [ ! "$*" ] && { cargo new || return $? }
        cargo new "$*"            || return $?
        cd "$1"                   || return $?
    }
    sandbox-fzf() {
        cd ~/code/sandbox || return $?
        if [ -n "$1" ]; then
            subdir="$1"
        else
            subdir=$(\ls | fzf --height=10 --layout=reverse) || return $?
        fi
        cd "$subdir" || return $?
        case "$subdir" in
            'java')
                tmux split-window -h -c "#{pane_current_path}" &&\
                tmux resize-pane -R 40 &&\
                tmux send-keys 'just run' Enter &&\
                tmux select-pane -L &&\
                nvim 'src/Main.java'
                ;;
                # tmux split-window -v -c "#{pane_current_path}" &&\
                # tmux send-keys 'just diff' Enter &&\
                # tmux select-pane -L &&\
                # tmux split-window -v -c "#{pane_current_path}" &&\
                # tmux send-keys 'nvim input' Enter &&\
                # tmux split-window -h -c "#{pane_current_path}" &&\
                # tmux send-keys 'nvim output' Enter &&\
                # tmux resize-pane -D 15 &&\
                # tmux select-pane -U &&\
            *)
                nvim .
                ;;
        esac
    }
    mkdir-cd() { # Make directory and cd
        mkdir -p "$*" || return $?
        cd "$*"       || return $?
    }
    garfeo-mode() { # https://github.com/dxrcy/garfeo
        cd ~/code/garfeo &&\
        tmux split-window -h -c "#{pane_current_path}" 'killall basic-http-server; just; zsh' &&\
        tmux resize-pane -R 40 &&\
        tmux select-pane -L &&\
        ~/scripts/cmd/garf edit &&\
        clear &&\
        printf '\x1b[32m' &&\
        title 'Garfield' &&\
        printf '\x1b[0m'
    }
    cd-last-command() { # Same as `cd !!`
        cd "$(fc -ln -1)" || return $?
    }
    ps-tree() { # Open process tree in Neovim
        # Search argument, or jump to bottom
        [ -n "$1" ] \
            && arg="+/$1" \
            || arg='+norm G'
        file="/tmp/ps-tree.$$"
        ps ax --forest -o 'cmd' > "$file" || return $?
        nvim "$file" '+set nowrap' "$arg" || return $?
    }

#========= PACKAGES
    # Autodownload packages
    # At end of file, so if git clone cancelled, above aliases still work
    # Package list entry is zsh file of package, relative to ~/.zsh
    PACKAGES=(
        zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh
	    dxrcy/zsh-history-substring-search/zsh-history-substring-search.zsh # Open PR
        hlissner/zsh-autopair/autopair.zsh
    )
    _dir="$HOME/.zsh" # Where to download packages to
    for _filepath in $PACKAGES; do
        _package="${_filepath%/*}" # Remove filename from path
        if [[ ! -d "$_dir/$_package" ]]; then
            printf "\x1b[2;33mzsh: installing '%s'...\x1b[0m\n" "$_package"
            git clone --quiet "https://github.com/$_package" "$_dir/$_package" || {
                printf "\x1b[31mzsh: some packages failed to download.\x1b[0m\n"
                break
            }
        fi
        source "$_dir/$_filepath"
    done
    # Settings for packages
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=15'
    bindkey '^[[A'       history-substring-search-up
    bindkey '^[[B'       history-substring-search-down
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
    HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

