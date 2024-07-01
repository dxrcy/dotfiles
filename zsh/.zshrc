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
        if [ "$KEYMAP" = "vicmd" ]
            then echo -ne "\e[1 q"
            else echo -ne "\e[5 q"
        fi
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
# Other keybinds
    bindkey -s '^D' ''      # Disable Ctrl+D
    bindkey -s '^Z' 'fg\n'  # Focus background task
# Change directory by typing name
    setopt AUTOCD
    alias   '...'='cd ../../'
    alias  '....'='cd ../../../'
    alias '.....'='cd ../../../../'
# Override `code` if in home
    code() {
        if [ "$PWD" = "$HOME" ];
            then cd 'code'
            else command code -r "$@"
        fi
    }
# Add scripts and binaries to path
    PATH="$HOME/scripts/cmd:$PATH"
    PATH="$HOME/.local/bin:$PATH"
# Auto aliases
    eval "$(zoxide init zsh)"
# Preferred editor for local and remote sessions
    if [[ -n $SSH_CONNECTION ]];
        then export EDITOR='vim'
        else export EDITOR='nvim'
    fi
# Override default browser
    BROWSER='librewolf'
# Persistant history
    export HISTFILE=~/.cache/zsh_history
    export HISTSIZE=2000
    export SAVEHIST=2000
    setopt SHARE_HISTORY        # Share history between terminals
    setopt HIST_IGNORE_ALL_DUPS # Duplicate history lines are ignored
    # See also: zsh-history-substring-search plugin
# Use case-insensitive autocompletions
    autoload -Uz compinit && compinit
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Fix i3-msg
    unset I3SOCK
# Misc. shorthand variables
    GH='https://github.com' # See also: `gcl`
    GH_MAIN='dxrcy'
    GH_STUDENT='dyrcyuni'
    GHU="$GH/$GH_MAIN"
# Shell nesting
    # export ZSHLVL_NOINC=once to disable for next child shell
    # export ZSHLVL_NOINC=all  to disable for all descendant shells
    # echo "$(date +%H:%M:%S)-$$=$ZSHLVL:$ZSHLVL_NOINC:$ZSHLVL_SET" >> ~/trace
    # echo "ZSHLVL: $ZSHLVL"
    # echo "ZSHLVL_NOINC: $ZSHLVL_NOINC"
    # echo "ZSHLVL_SET: $ZSHLVL_SET"
    if [ -z "$ZSHLVL" ]; then
        ZSHLVL=1
    elif [ -n "$ZSHLVL_NOINC" ]; then
        [ "$ZSHLVL_NOINC" = 'all' ] || unset ZSHLVL_NOINC
    else
        ZSHLVL=$((ZSHLVL + 1))
    fi
    # if [ -n "$ZSHLVL_SET" ]; then
    #     ZSHLVL="$ZSHLVL_SET"
    # fi
    export ZSHLVL
# Bind shift-tab to cycle backwards in completion
    bindkey "^[[Z" reverse-menu-complete
# Disable command-specific tab completions
    # Just list commands and files
    zstyle ':completion:*' completer _files _command_names
# XDG base directories
    export XDG_CONFIG_HOME="$HOME/.config"
    export XDG_CACHE_HOME="$HOME/.cache"
    export XDG_DATA_HOME="$HOME/.local/share"
    export XDG_STATE_HOME="$HOME/.local/state"

#========= THESE SHOULD BE REMOVED AT SOME POINT!
# Fix zsh tab completion when using `eza` package
    # _exa() { eza }
# zstyle ':completion:*' menu select # select completions with arrow keys
# zstyle ':completion:*' group-name '' # group results by category
# zstyle ':completion:::::' completer _expand _complete _ignored _approximate #enable approximate matches for completion

#========= PROMPT
# Display shell nesting level
    # Variable, not function (unlike below)
    _arrow=''
    [ -n "$ZSHLVL" ] && \
        for _ in $(seq 2 $ZSHLVL); do
            _arrow="$_arrow="
        done
    [ $_arrow ] && _arrow="$_arrow> "
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
    alias   gc='git commit'
    alias  gac='git add -A && git commit'
    alias  gca='git commit --amend'
    alias   gp='git push'
    alias   gd='git diff'
    alias   gl='git log'
    alias   gr='git remote'
    alias grao='git remote add     origin'
    alias grro='git remote remove  origin'
    alias grso='git remote set-url origin'
    alias grgo='git remote get-url origin'
    alias  gcl='git-clone-cd'
    alias  ghu='gh-url'
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
    alias tree='ls -T -I target'
    alias treea='tree -a'
    alias find='fd'
    alias finda='fd -HI'
    alias grep="rg"
    alias grepa="rg --hidden --no-ignore"
    alias mkdir='mkdir -p'
    alias cp='cp -r'
    alias nsxiv='nsxiv -a'
    alias sxiv='nsxiv'
    alias zig='~/.zvm/bin/zig'
    alias pstree='pstree -U | less'
    alias zh='vim + ~/.cache/zsh_history'
    alias zr='unalias -a; ZSHLVL_NOINC=1 source ~/.zshrc'
    alias mkd='mkdir-cd'
    alias eo='garfeo-mode'
    alias ll='cd-last-command'
    alias mpv='mpv --script=~/.config/mpv/mpv-cheatsheet.js'
    alias gcc='gcc -Wall -Wpedantic'
    alias wcl='wc -l'
# Misc. Abbreviations / Mispellings
    alias dc='cd - >/dev/null'
    alias j='just'
    alias m='make'
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
    alias ssy='sudo systemctl'
    alias syu='systemctl --user'
    alias ping1='ping 1.1.1.1 -c 10'
    alias cal3='cal -3'
    alias doas="echo -e \"\x1b[34mdoas I do:\x1b[0m \x1b[1msudo\x1b[0m\""
    alias pk='pkill'
    alias btc='bluetoothctl'
    alias plc='bluetoothctl'
    alias bhs='basic-http-server'
    alias rl='readlink'
    alias pst='ps-tree'
    alias backup='backup-file' # Script
    alias entra='entr-all'
    alias ghs='gh auth switch'
    alias s='sandbox-fzf'
    alias lf='lf-cd' 
    am() { garf make $* && exit }

#========= LONGER FUNCTIONS (Aliased)
    lf-cd() { # Use lf to `cd`, without spawning subshell
        target="$(\lf -print-last-dir)"
        [ -d "$target" ] && cd "$target"
        # Also open file if triggered (see lfrc)
        editfile='/tmp/lf-editfile'
        if [ -f "$editfile" ]; then
            nvim "$(cat "$editfile")"
            rm "$editfile"
        fi
    }
    gh-url() { # Git url shorthand
        url="$1"
        case "$url" in
            '') return 1 ;;
            @*) echo "$GH/${url:1}" ;;
            :*) echo "$GHU/${url:1}" ;;
             *) echo "$url" ;;
         esac
    }
    git-clone-cd() { # Git clone alias with URL shorthand, and cd
        url="$(gh-url $1)" || { git clone ; return $?; }
        shift
        git clone "$url" $* || return $?
        target="$1" # Target directory argument, or use URL path
        [ -z "$target" ] && target="${${url##*/}%.git}" 
        cd "$target"
    }
    gh-switch() {
        if git config --get 'user.email' 'student' >/dev/null;
            then account="$GH_STUDENT"
            else account="$GH_MAIN"
        fi
        gh auth switch -u "$account"
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
            'rust') nvim 'src/main.rs' ;;
            'c')    nvim 'main.c' ;;
            'zig')  nvim 'main.zig' ;;
            'java')
                tmux split-window -h -c "#{pane_current_path}" &&\
                tmux resize-pane -R 40 &&\
                tmux send-keys 'just run' Enter &&\
                tmux select-pane -L &&\
                nvim 'src/Main.java'
                ;;
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
        if [ -n "$1" ]
            then arg="+/$1"
            else arg='+norm G'
        fi
        file="/tmp/ps-tree.$$"
        ps ax --forest -o 'cmd' > "$file" || return $?
        nvim "$file" '+set nowrap' "$arg" || return $?
    }

#========= PACKAGES
    # Autodownload packages
    # At end of file, so if git clone cancelled, above aliases still work
    PKGDIR="$HOME/.zsh" # Where to download packages to
    PACKAGES=( # Each item is the zsh entry file of package, relative to PKGDIR
        zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh
	    zsh-users/zsh-history-substring-search/zsh-history-substring-search.zsh
        hlissner/zsh-autopair/autopair.zsh
    )
    # Clean packages
    for _dir_full in $PKGDIR/*/*(N); do # List all installed packages
        _dir=${_dir_full#$PKGDIR/} # Remove pkgdir from path
        unset _found
        for _filepath in $PACKAGES; do # Check if package is in list
            _package="${_filepath%/*}" # Remove filename from path
            if [ "$_package" = "$_dir" ]; then
                _found=1
                break
            fi
        done
        if [ -z "$_found" ]; then # Remove if not in list
            printf "\x1b[2;31mzsh: removing old package '%s'...\x1b[0m\n" "$_dir"
            rm -rf "$_dir_full"
        fi
    done
    # Clean package parent directories
    for _author_full in $PKGDIR/*(N); do
        if [ -z "$(\ls "$_author_full")" ]; then
            rm -r "$_author_full"
        fi
    done
    # Install packages
    for _filepath in $PACKAGES; do
        _package="${_filepath%/*}" # Remove filename from path
        if [ ! -d "$PKGDIR/$_package" ]; then # Check if not installed
            printf "\x1b[2;33mzsh: installing '%s'...\x1b[0m\n" "$_package"
            if ! git clone --quiet "https://github.com/$_package" "$PKGDIR/$_package"; then
                printf "\x1b[31mzsh: some packages failed to download.\x1b[0m\n"
                break
            fi
        fi
        source "$PKGDIR/$_filepath" # Load package
    done

    # Settings for packages
    # Will not be applied if package installation is interrupted
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=15'
    bindkey '^[[A'       history-substring-search-up
    bindkey '^[[B'       history-substring-search-down
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
    HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

