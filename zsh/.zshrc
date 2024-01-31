#!/bin/zsh
# -------------------------
# Blazingly fast Zsh config
# -------------------------

#========= MISC
# Auto aliases
    eval "$(zoxide init zsh)"
# Preferred editor for local and remote sessions
    [[ -n $SSH_CONNECTION ]] \
        && export EDITOR='vim' \
        || export EDITOR='nvim'
# Override default browser
    BROWSER='librewolf'
# Add scripts to path
    PATH="$HOME/scripts/cmd:$PATH"
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
    # Add missing keybinds
    bindkey -s -M vicmd '\_' '^'
    # Yank to the system clipboard
    function vi-yank-xclip {
        zle vi-yank
        echo "$CUTBUFFER" | xclip -selection clipboard
    }; zle -N vi-yank-xclip
    bindkey -M vicmd 'y' vi-yank-xclip
# Other keybinds
    bindkey -s '^Z' 'fg\n'
# Change directory by typing name
    setopt AUTOCD
    alias   '...'='cd ../../'
    alias  '....'='cd ../../../'
    alias '.....'='cd ../../../../'
# Persistant history
    HISTFILE=~/.cache/zsh_history
    HISTSIZE=1000
    SAVEHIST=1000
    setopt SHARE_HISTORY        # Share history between terminals
    setopt HIST_IGNORE_ALL_DUPS # Duplicate history lines are ignored
    # See also: zsh-history-substring-search plugin
# Use case-insensitive autocompletions
    autoload -Uz compinit && compinit
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Fix zsh tab completion when using `eza` package
    _exa() { eza }
# Flyctl binary
    export FLYCTL_INSTALL="/home/darcy/.fly"
    export PATH="$FLYCTL_INSTALL/bin:$PATH"
# Fix i3-msg
    unset I3SOCK
# Shell nesting
    [ -z $ZSH ] && ZSH=0 \
        || { [ -z $ZSH_NOINC ] && ZSH=$((ZSH + 1)); }
    export ZSH

#========= PROMPT
    # Colors
    local       rc='%f%F{white}' # Reset
    local    userc='%F{yellow}'  # Username
    local      atc='%F{green}'   # @ symbol
    local    hostc='%F{blue}'    # Hostname
    local     dirc='%F{magenta}' # Directory
    local    jobsc='%F{cyan}'    # Jobs count
    local gbranchc='%F{blue}'    # Git branch
    local   ginfoc='%F{red}'     # Git info
    local versionc="%F{green}"   # Package version
    local    exitc='%F{cyan}'    # Prompt symbol (exit 1)
    local  promptc='%F{green}'   # Prompt symbol (exit 0)
    # Wrap custom commands with color
    setopt PROMPT_SUBST          # Allow functions in prompt
    git_branch() { x=$(git-info -b);  [ "$x" ] && echo "$gbranchc $x" }
    git_status() { x=$(git-info);     [ "$x" ] && echo "$ginfoc [$x]" }
    version() { x=$(package-version); [ "$x" ] && echo "$versionc\x1b[2m v$x$rc\x1b[0m" }
    # Shell nesting
    local arrow=''
    for _ in $(seq 1 $ZSH); do arrow="$arrow="; done
    [ $arrow ] && { arrow="$arrow> "; }
    # Make prompt
export PS1="%F{cyan}$arrow%B$userc%n%b$atc@%B$hostc%m%b $dirc%3~\$(git_branch)\$(git_status)\$(version)$exitc%(0?.. ·)
$jobsc%(1j.[%j].)$promptc❯$rc "

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
    alias   Z='exit'
    alias  ZZ='exit'
# Git (even tho lazygit is easier)
    alias    g='git'
    alias   ga='git add'
    alias   gc='git commit -m'
    alias  gac='git add . && git commit -m'
    alias  gca='git commit --amend -m'
    alias   gp='git push'
    alias   gd='git diff'
    alias   gl='git log'
    alias  gcl='git clone'
    alias   gr='git remote'
    alias grao='git remote add origin'
    alias grro='git remote remove origin'
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
    alias  cwc='cargo watch -x clippy -c'
    alias  cwt='cargo watch -x test -c'
    alias   ci='cargo install'
    alias  cip='cargo install --path .'
    alias  cex='cargo expand | nvim -Rc "set ft=rust"' # Expand macro, open in nvim
    alias  ccl='cargo clippy'
    cn() { # cargo new
        [ ! "$*" ] && { cargo new || return $? }
        cargo new "$*"            || return $?
        cd "$1"                   || return $?
    }
# Common dotfile editing
    alias  d.='cd ~/dotfiles'
    alias d.z='cd ~/dotfiles/zsh                   && nvim .zshrc'
    alias d.v='cd ~/dotfiles/nvim/.config/nvim     && nvim .'
    alias d.t='cd ~/dotfiles/tmux/.config/tmux     && nvim tmux.conf'
    alias d.i='cd ~/dotfiles/i3/.config/i3         && nvim config'
# Misc. Programs
    alias cat='bat'
    alias ls='eza -l'
    alias lsa='ls -a'
    alias tree='ls -T'
    alias treea='ls -T -a'
    alias mkdir='mkdir -p'
    alias cp='cp -r'
    alias grep='rg'
    # alias grep='grep --color=auto'
    # alias grepr='grep -R --exclude-dir .git --exclude-dir target'
    alias nsxiv='nsxiv -a'
    alias sxiv='nsxiv'
    alias vhistory='v ~/.cache/zsh_history'
    # Use lf to `cd`, without spawning subshell
    alias lf='cd "$(\lf -print-last-dir)"'
    # Undo last `cd`
    alias cd='LASTDIR="$(pwd)"; cd'      # Save working directory
    alias dc='_DIR=$LASTDIR; cd "$_DIR"' # Go back to previous directory
    # Make directory and cd
    mkd() {
        mkdir -p "$*" &&\
        cd "$*"
    }
    # Garfeo
    eo() {
        cd ~/code/garfeo &&\
        tmux split-window -h -c "#{pane_current_path}" 'killall basic-http-server; just; zsh' &&\
        tmux resize-pane -R 40 &&\
        tmux select-pane -L &&\
        clear &&\
        printf '\x1b[32m' &&\
        title 'Garfield' &&\
        printf '\x1b[0m'
    }
# Misc. Abbreviations / Mispellings
    alias j='just'
    alias a='garf'
    alias o='xdg-open'
    alias :='abandon' # Script
    alias th='thunar'
    alias lw='librewolf'
    alias lg='lazygit' # also in tmux
    alias clip='xclip -selection clipboard'
    alias scim='sc-im'
    alias trs='tree-sitter'
    alias ol='ollama'
    alias olr='ollama run mistral'
    alias sy='systemctl'
    alias syu='systemctl --user'
    alias ping8='ping 8.8.8.8 -c 10'
    alias cal3='cal -3'
    alias doas="echo -e \"\x1b[34mdoas I do:\x1b[0m \x1b[1msudo\x1b[0m\""
    alias sb='cd ~/code/sandbox && v src/main.rs'
    alias zr='unalias -a; ZSH_NOINC=1 source ~/.zshrc'
    alias pk='pkill'
    alias z='zi'
    alias r='lf'

#========= PACKAGES
    # Autodownload packages
    # At end of file, so if git clone cancelled, above aliases still work
    # Package list entry is zsh file of package, relative to ~/.zsh
    PACKAGES=(
        zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh
	    zsh-users/zsh-history-substring-search/zsh-history-substring-search.zsh
        hlissner/zsh-autopair/autopair.zsh
    )
    _dir="$HOME/.zsh" # Where to download packages to
    for _filepath in $PACKAGES; do
        _package="${_filepath%/*}" # Remove filename from path
        if [[ ! -d "$_dir/$_package" ]]; then
            printf "\x1b[2;33mInstalling '%s'...\x1b[0m\n" "$_package"
            git clone --quiet "https://github.com/$_package" "$_dir/$_package" || {
                printf "\x1b[31mSome packages failed to download.\x1b[0m\n"
                break
            }
        fi
	source "$_dir/$_filepath"
    done
    unset _dir _filepath _package
    # Settings for packages
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=15'
    bindkey '^[[A'       history-substring-search-up
    bindkey '^[[B'       history-substring-search-down
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
    HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

