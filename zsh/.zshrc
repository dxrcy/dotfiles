#!/bin/zsh
# -------------------------
# Blazingly fast Zsh config
# -------------------------

#========= RUNNING IN PRIMARY TTY
    # Source ~/.profile in any tty
    if [ -z "$DISPLAY" ]; then
        [ -f "$HOME/.profile" ] && . "$HOME/.profile"
        # Explicitly source XDG base directories (in case .profile fails)
        [ -f "$HOME/.config/user-dirs.dirs" ] && . "$HOME/.config/user-dirs.dirs"
    fi

    # Ask to run display server (or `startx`)
    # Runs at end of file
    _display-server-prompt() {
        if [ -z "$DISPLAY" ] && [ "$TTY" = "/dev/tty1" ]; then
            echo
            printf '\x1b[1mStart graphical session? \x1b[0m'
            read -r _

            export ZSHLVL=0 # Reset shell nesting
            hyprland # WM/DE or `startx`
        fi
    }

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
    # TODO: Wayland
    function vi-yank-xclip {
        zle vi-yank
        echo "$CUTBUFFER" | wl-copy
    }; zle -N vi-yank-xclip
    bindkey -M vicmd 'y' vi-yank-xclip
    bindkey -M vicmd -s 'ŝ' 'q' # Remap Esperanto keys
    bindkey -M vicmd -s 'ĝ' 'w'
    bindkey -M vicmd -s 'ŭ' 'y'
    bindkey -M vicmd -s 'ĵ' '['
    bindkey -M vicmd -s 'ĥ' ']'
    bindkey -M vicmd -s 'ĉ' 'x'
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
    bindkey '^Z' fg-keybind
# Zoxide keybind
    zoxide-keybind() {
        eval z
        zle reset-prompt
    }; zle -N zoxide-keybind
    bindkey '^ ' zoxide-keybind
# Other keybinds
    bindkey -s '^D' ''      # Disable Ctrl+D
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
    # Does not change order if dir is already in PATH
    prepend-path() {
        dir="$1"
        [ -d "$dir" ] || return 1
        case "$PATH" in
            "$dir")     ;;  # Only item
            "$dir:"*)   ;;  # At start
            *":$dir")   ;;  # At end
            *":$dir:"*) ;;  # In middle
            *) PATH="$dir:$PATH" ;;
        esac
    }
    prepend-path "$HOME/scripts/cmd"
    prepend-path "$HOME/.local/bin"
# Auto aliases
    eval "$(zoxide init zsh)"
# Preferred editor for local and remote sessions
    if [[ -n $SSH_CONNECTION ]];
        then export EDITOR='vim'
        else export EDITOR='nvim'
    fi
# Persistant history
    export HISTFILE=~/.cache/zsh_history
    export HISTSIZE=5000
    export SAVEHIST=5000
    setopt SHARE_HISTORY        # Share history between terminals
    setopt HIST_IGNORE_ALL_DUPS # Duplicate history lines are ignored
    setopt HIST_IGNORE_SPACE    # Don't save commands that start with space
    # See also: zsh-history-substring-search plugin
# Use case-insensitive autocompletions
    autoload -Uz compinit && compinit
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Misc. shorthand variables
    GH='https://github.com' # See also: `gcl`
    GH_MAIN='dxrcy'
    GH_STUDENT='dyrcyuni'
    GHU="$GH/$GH_MAIN"
# Shell nesting
    if [ -z "$ZSHLVL" ]; then
        ZSHLVL=1
    elif [ -n "$ZSHLVL_NOINC" ]; then
        [ "$ZSHLVL_NOINC" = 'all' ] || unset ZSHLVL_NOINC
    else
        ZSHLVL=$((ZSHLVL + 1))
    fi
    export ZSHLVL
# Disable command-specific tab completions
    # Only list commands and files
    zstyle ':completion:*' completer _files _command_names
# Bind shift-tab to cycle backwards in completion
    bindkey "^[[Z" reverse-menu-complete
# Move zcompdump file location
    compinit -d "$HOME/.cache/zsh/zcompdump-$ZSH_VERSION"
# XDG base directory aliases
    XCONF="$XDG_CONFIG_HOME"
    XCACHE="$XDG_CACHE_HOME"
    XDATA="$XDG_DATA_HOME"
    XSTATE="$XDG_STATE_HOME"
# Use neovim as man pager
    export MANPAGER='nvim +Man!'

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
# Misc.
    _dot='·'
    _gt='❯'
# Make PS1
    PS1_GIT=1
    ps1-git() { # Toggle Git information in PS1 (if running slow)
        if [ -n "$PS1_GIT" ];
            then unset PS1_GIT
            else PS1_GIT=1
        fi
        _set_ps1
    }
    #        BOLD     COLOR           VALUE
    _set_ps1() {
        _PS=''
        _prompt         "%F{cyan}"      "$_arrow"       # Shell nesting level
        _prompt  "%B"   "%F{yellow}"    "%n"            # Username
        _prompt         "%F{green}"     "@"             # @
        _prompt  "%B"   "%F{blue}"      "%m"            # Hostname
        _prompt                         ' '             #
        _prompt         "%F{magenta}"   "%3~"           # Last 3 folders of PWD
        if [ -n "$PS1_GIT" ]; then
            _prompt                         '$(git_branch)' # Git: Branch
            _prompt                         '$(git_status)' # Git: Status
        fi
        _prompt                         '$(version)'    # Package version (also dim)
        _prompt         "%F{cyan}"      "%(0?.. $_dot)" # Non-zero exit code = dot
        _prompt                         $'\n'           #
        _prompt         "%F{cyan}"      "%(1j.[%j].)"   # Job count
        _prompt         '%F{green}'     "$_gt "         # >
        PS1="$_PS"
    }
    _set_ps1

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
# Rust (cargo)
    alias    c='cargo'
    alias   cr='cargo run'
    alias   cc='cargo check'
    alias   ct='cargo test'
    alias   cb='cargo build'
    alias  crr='cargo run --release'
    alias  cbr='cargo build --release'
    alias cdoc='cargo doc --no-deps --open'
    alias   cw='cargo watch -c'
    alias  cwr='cargo watch -x run -c'
    alias  cwb='cargo watch -x build -c'
    alias  cwc='cargo watch -c'
    alias cwcl='cargo watch -x clippy -c'
    alias  cwt='cargo watch -x test -c'
    alias   ci='cargo install'
    alias  cip='cargo-install-path'
    alias  cex='cargo expand | nvim -Rc "set ft=rust"' # Expand macro, open in nvim
    alias  ccl='cargo clippy'
    alias   cn='cargo-new-cd'
# Common dotfile editing
    alias .d='cd ~/dotfiles'
    alias .z='cd ~/dotfiles/zsh                     && nvim .zshrc'
    alias .v='cd ~/dotfiles/nvim/.config/nvim       && nvim'
    alias .h='cd ~/dotfiles/hyprland/.config/hypr   && nvim hyprland.conf'
    alias .y='cd ~/dotfiles/yazi/.config/yazi       && nvim'
    alias sc='cd ~/scripts                          && nvim cmd'
# Misc. Programs and options
    alias cat='bat'
    alias ls='eza -l --group-directories-first'
    alias lsa='ls -a'
    alias lst='eza -l --total-size --sort size --reverse'
    alias lsta='lst -a'
    alias tree='ls -T -I target'
    alias treea='tree -a'
    alias find='fd'
    alias finda='fd -HI'
    alias grep="rg"
    alias grepa="rg --hidden --no-ignore"
    alias mkdir='mkdir -p'
    alias cp='cp -r'
    alias swiv='swiv -a -B#000000'
    alias zig='~/.zvm/bin/zig'
    alias pstree='pstree -U | less'
    alias zh='vim + ~/.cache/zsh_history'
    alias zr='unalias -a; ZSHLVL_NOINC=1 source ~/.zshrc'
    alias mpv='mpv --script=~/.config/mpv/mpv-cheatsheet.js'
    alias gcc='gcc -Wall -Wpedantic'
    alias wcl='wc -l'
    alias journalctl='journalctl -e'
    alias jnl='journalctl'
# Misc. Abbreviations / mispellings
    alias nvim='nvim-dir'
    alias vim='nvim'
    alias v='nvim'
    alias dc='cd - >/dev/null'
    alias j='just'
    alias m='make'
    alias d='devour'
    alias z='zi'
    alias r='yazi'
    alias th='thunar'
    alias lg='lazygit'
    alias sy='systemctl'
    alias ssy='sudo systemctl'
    alias syu='systemctl --user'
    alias ping1='ping 1.1.1.1 -c 10'
    alias cal3='cal -3'
    alias pk='pkill'
    alias btc='bluetoothctl'
    alias bhs='basic-http-server'
    alias rl='readlink'
    alias ghs='gh auth switch'
    alias print='printf' # Prevent terrible problems!
# Custom scripts and functions
    alias p='pacman-thing'
    alias a='garfutils' # deprecated
    alias gu='garfutils'
    alias o='open' # deprecated
    alias ,='abandon'
    alias ,,='abandon-exit'
    alias backup='backup-file' # Script
    alias s='sandbox-fzf'
    alias yazi='yazi-cd'
    alias mkd='mkdir-cd'
    alias eo='garfeo-mode'
    alias ll='cd-last-command'
    alias pst='ps-tree'
    am() { garfutils make $* && exit }
    # Alised elsewhere: `cargo-new-cd`, `nvim-dir`, `git-*`

#========= LONGER FUNCTIONS (Aliased)
    nvim-dir() { # Open folder in nvim, instead of new buffer
        if [ "$*" ];
            then \nvim $*
            else \nvim +'lua require("yazi").yazi()'
        fi
    }
    yazi-cd() { # Use `yazi` to `cd`, without spawning subshell
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
        \yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            cd -- "$cwd"
        fi
        rm -f -- "$tmp"
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
        if [ -z "$target" ]; then
            # Extract repository name from url
            target="$(echo "$url" \
                | sed 's|/$||' \
                | sed 's|\.git$||' \
                | sed 's|^.*/||'\
            )"
        fi
        cd "./$target"
    }
    gh-switch() {
        if git config --get 'user.email' 'student' >/dev/null;
            then account="$GH_STUDENT"
            else account="$GH_MAIN"
        fi
        gh auth switch -u "$account"
    }
    ghcr() { # Haskell (ghc)
        ghc -Wall -dynamic $* >/dev/null || return $?
        ./"${1%%.hs}"
    }
    gccr() { # C (gcc)
        out="${1%.c}"
        gcc "$1" -o "$out" || return $?
        shift
        ./"$out" "$@"
        code="$?"
        [ "$code" = 139 ] && echo "Segfault! lol."
        return "$code"
    }
    gppr() { # C++ (g++)
        in="$1"
        out="${in%.cpp}"
        shift
        g++ "$in" -o "$out" $* || return $?
        ./"$out"
        code="$?"
        [ "$code" = 139 ] && echo "Segfault! lol."
        return "$code"
    }
    cargo-install-path() { # Install package at current project root
        root=$(dirname "$(cargo locate-project | jq -r .root)")
        cargo install --path "$root"
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
            'roc')  nvim 'main.roc' ;;
            'lua')  nvim 'main.lua' ;;
            'cpp')
                tmux split-window -h -c "#{pane_current_path}" &&\
                tmux resize-pane -R 30 &&\
                tmux select-pane -L &&\
                nvim 'main.cpp'
                ;;
            'java')
                tmux split-window -h -c "#{pane_current_path}" &&\
                tmux resize-pane -R 20 &&\
                tmux send-keys 'just run' 'Enter' &&\
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
        # Set grouped if not already
        [ "$(hyprctl activewindow -j | jq -r '.grouped | length')" -eq 0 ] \
             && hyprctl dispatch togglegroup
        cd ~/code/garfeo &&\
        tmux split-window -h -c '#{pane_current_path}' 'killall basic-http-server; just; zsh' &&\
        tmux resize-pane -R 40 &&\
        tmux select-pane -L &&\
        clear &&\
        printf '\x1b[32m' &&\
        title 'Garfield' &&\
        printf '\x1b[0m' &&\
        tmux new-window -c ~/pics/eo 'yazi; zsh'
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
    abandon() {
        eval $* & disown
    }
    abandon-exit() {
        abandon $*
        exit
    }
    pdflatex-bibtex() {
        file="$1"
        pdflatex "$file.tex" || return $?
        bibtex "$file" || return $?
        pdflatex "$file.tex" || return $?
        pdflatex "$file.tex" || return $?
    }
    pdflatex-watch() {
        compile='pdflatex-bibtex'
        file="$1"

        "$compile" "$file"
        if [ ! "$(lsof -Fc 'a2.pdf' | sed -n 's/^c//p')" = 'zathura' ]; then
            zathura "$file.pdf" & disown
        fi
        printf "$file.tex\n$file.bib" \
            | entr -np zsh -ci "$compile '$file'"
    }
    latex-clean() {
        file="$1"
        if [ -z "$file" ] || [ ! -f "$file.tex" ]; then
            echo "latex-clean: no tex file found" >&2
            return 1
        fi
        trash "$file-blx.bib" 2>/dev/null
        trash "$file.aux"     2>/dev/null
        trash "$file.bbl"     2>/dev/null
        trash "$file.bcf"     2>/dev/null
        trash "$file.blg"     2>/dev/null
        trash "$file.blg"     2>/dev/null
        trash "$file.log"     2>/dev/null
        trash "$file.out"     2>/dev/null
        trash "$file.run.xml" 2>/dev/null
    }

#========= PACKAGES
    # Autodownload packages
    # At end of file, so if git clone cancelled, above aliases still work
    _install-packages() {
        PKGDIR="$HOME/.local/share/zsh" # Where to download packages to
        PACKAGES=( # Each item is the zsh entry file of package, relative to PKGDIR
            zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
            zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh
            zsh-users/zsh-history-substring-search/zsh-history-substring-search.zsh
            hlissner/zsh-autopair/autopair.zsh
        )
        [ -e "$PKGDIR" ] || mkdir -p "$PKGDIR"
        if [ ! -d "$PKGDIR" ] || [ ! -w "$PKGDIR" ]; then
            printf "\x1b[2;31mzsh: cannot access package directory at '%s'.\x1b[0m\n" "$PKGDIR"
            return 1
        fi
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
                    printf "\x1b[31mzsh: failed to download package '%s'.\x1b[0m\n"
                    continue
                fi
            fi
            . "$PKGDIR/$_filepath" # Load package
        done
        # Settings for packages
        # Will not be applied if package installation is interrupted
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=15'
        bindkey '^[[A'       history-substring-search-up
        bindkey '^[[B'       history-substring-search-down
        bindkey -M vicmd 'k' history-substring-search-up
        bindkey -M vicmd 'j' history-substring-search-down
        HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
    }

_install-packages
_display-server-prompt

# TODO: Move these things

# pnpm
export PNPM_HOME="/home/darcy/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# TODO(feat): `node` command, which lazily sources `nvm` script

if [ -e /home/darcy/.nix-profile/etc/profile.d/nix.sh ]; then . /home/darcy/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# source /usr/share/nvm/init-nvm.sh
