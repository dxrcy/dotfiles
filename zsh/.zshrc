#!/bin/zsh
# -------------------------
# Blazingly fast Zsh config
# -------------------------

#========= MISC
# Auto aliases
    eval "$(zoxide init zsh)"
# Preferred editor for local and remote sessions
    if [[ -n $SSH_CONNECTION ]]; then export EDITOR='vim'
        else                          export EDITOR='nvim'; fi
# Override default browser
    BROWSER='librewolf'
# Add scripts to path
    PATH="$HOME/scripts/cmd:$PATH"
# Vi mode in prompt (best mode)
    bindkey -v
    export KEYTIMEOUT=1 # idk ?
    bindkey -v '^?' backward-delete-char # fix backspace
# Change directory by typing name
    setopt AUTOCD
    alias   '...'='cd ../../'
    alias  '....'='cd ../../../'
    alias '.....'='cd ../../../../'
# Persistant history
    HISTFILE=~/.cache/zsh_history
    HISTSIZE=10000
    SAVEHIST=10000
    setopt SHARE_HISTORY        # share history between terminals
    setopt HIST_IGNORE_ALL_DUPS # duplicate history lines are ignored
# Use case-insensitive autocompletions
    autoload -Uz compinit && compinit
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Fix zsh tab completion when using `eza` package
    _exa() { eza }
# Flyctl binary
    export FLYCTL_INSTALL="/home/darcy/.fly"
    export PATH="$FLYCTL_INSTALL/bin:$PATH"

#========= PROMPT
    # Colors
    local rc='%f%F{white}'    # Reset
    local userc='%F{yellow}'  # Username
    local atc='%F{green}'     # @ symbol
    local hostc='%F{blue}'    # Hostname
    local dirc='%F{magenta}'  # Directory
    local jobsc='%F{cyan}'    # Jobs count
    local gbranchc='%F{blue}' # Git branch
    local ginfoc='%F{red}'    # Git info
    local versionc="%F{green}" # Package version
    local exitc='%F{cyan}'    # Prompt symbol (exit 1)
    local promptc='%F{green}' # Prompt symbol (exit 0)
    # Wrap `git-info` output with color
    git_branch() { x=$(git-info -b); [ "$x" ] && echo "$gbranchc $x" }
    git_status() { x=$(git-info);    [ "$x" ] && echo "$ginfoc [$x]" }
    version() { x=$(package-version); [ "$x" ] && echo "$versionc\x1b[2m v$x$rc\x1b[0m" }
    setopt PROMPT_SUBST       # Allow functions in prompt
export PS1="%B$userc%n%b$atc@%B$hostc%m%b $dirc%3~\$(git_branch)\$(git_status)\$(version)$exitc%(0?.. ·)
$jobsc%(1j.[%j].)$promptc❯$rc "

#========= ALIASES
# Tmux
    alias t='tmux'
    alias ta='tmux -u attach'
# Exit (vim style)
    alias q='exit'
    alias :q='exit'
    alias :wq='exit'
    alias Z='exit'
    alias ZZ='exit'
# Git (even tho lazygit is easier)
    alias ga='git add'
    alias gc='git commit -m $1'
    alias gac='git add . && git commit -m $1'
    alias gp='git push'
    alias gd='git diff'
    alias gl='git log'
    alias gcl='git clone'
    alias gitignore='cat .gitignore'
    alias gr='git remote'
    alias grao='git remote add origin'
# Nvim
    # Open folder in nvim, instead of new buffer
    v() { if [ "$1" ]; then nvim $1; else nvim .; fi }
    alias vim='nvim'
# Pacman wrapper script
    alias p='pacman-thing'
# Rust (cargo)
    alias c='cargo'
    alias cr='cargo run'
    alias cb='cargo build'
    alias cc='cargo check'
    alias ct='cargo test'
    alias crr='cargo run --release'
    alias cbr='cargo build --release'
    alias cdoc='cargo doc --no-deps --open'
    alias cw='cargo watch -c'
    alias cwr='cargo watch -x run -c'
    alias cwc='cargo watch -x clippy -c'
    alias cwt='cargo watch -x test -c'
    alias ci='cargo install --path .'
    alias cex='cargo expand | nvim -Rc "set ft=rust"' # Expand macro, open in nvim
    alias ccl='cargo clippy'
    # cargo new
    cn() {
        [ ! "$1" ] && { cargo new || return $? }
        cargo new "$1"            || return $?
        cd "$1"                   || return $?
    }
# Dotfile editing
    alias d.='cd ~/dotfiles'
    alias d.z='cd ~/dotfiles/zsh                   && nvim .zshrc'
    alias d.v='cd ~/dotfiles/nvim/.config/nvim     && nvim .'
    alias d.t='cd ~/dotfiles/tmux/.config/tmux     && nvim tmux.conf'
    alias d.r='cd ~/dotfiles/ranger/.config/ranger && nvim rc.conf'
    alias d.i='cd ~/dotfiles/i3/.config/i3         && nvim config'
    alias d.k='cd ~/dotfiles/kitty/.config/kitty   && nvim kitty.conf'
    alias d.m='cd ~/dotfiles/mutt/.config/mutt     && nvim muttrc'
# Misc. Programs
    alias ls='eza -l'
    alias lsa='ls -a'
    alias tree='ls -T'
    alias grep='grep --color=auto'
    alias grepr='grep -R --exclude-dir .git --exclude-dir target'
    alias cat='bat'
    alias g='garf'
    alias j='just'     # also in tmux
    alias lg='lazygit' # also in tmux
    alias o='xdg-open'
    alias r='ranger'
    alias lw='librewolf'
    alias cp='cp -r'
    alias mkdir='mkdir -p'
    alias clip='xclip -selection clipboard'
    alias wiki='wiki-tui'
    alias scim='sc-im'
    alias trs='tree-sitter'
    alias th='thunar'
    alias ol='ollama'
    alias olr='ollama run mistral'
    alias en='translate eo en'
    alias eo='translate en eo'
    alias nsxiv='nsxiv -a'
    alias sxiv='nsxiv'
# Misc
    alias ping8='ping 8.8.8.8 -c 10'
    alias doas="echo -e \"\x1b[34mdoas I do:\x1b[0m \x1b[1msudo\x1b[0m\""

#========= PACKAGES
    # Autodownload packages
    # At end of file, so if git clone cancelled, above aliases still work
    packages=(
        zsh-users/zsh-syntax-highlighting
        zsh-users/zsh-autosuggestions
        hlissner/zsh-autopair
    )
    for package in $packages; do
        if [[ ! -d ~/.zsh/$package ]]; then
            git clone https://github.com/$package ~/.zsh/$package;
        fi
    done
    unset packages package
    # Source manually
    source ~/.zsh/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh
    source ~/.zsh/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source ~/.zsh/hlissner/zsh-autopair/autopair.zsh
    # Settings for packages
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=15'

#========= OLD
# Start tmux if not already running
    # Don't use with i3
    # if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [ ! "$NO_TMUX" ]; then
    #     exec tmux; fi
# Node binaries (should be in .profile i think)
    # export PATH=$PATH:./node_modules/.bin

