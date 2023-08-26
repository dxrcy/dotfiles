#!/bin/zsh
# -------------------------
# Blazingly fast Zsh config
# -------------------------

#========= MISC
# Starship prompt
    eval "$(starship init zsh)" # A bit slow :(
# Auto aliases
    eval "$(zoxide init zsh)"
# Start tmux if not already running
    if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
        exec tmux; fi
# Preferred editor for local and remote sessions
    if [[ -n $SSH_CONNECTION ]]; then export EDITOR='vim'
        else                          export EDITOR='nvim'; fi
# Override default browser
    BROWSER='librewolf'
# Add scripts to path
    PATH="$HOME/scripts:$PATH"
# Node binaries (should be in .profile i think)
    export PATH=$PATH:./node_modules/.bin
# Vi mode in prompt (best mode)
    bindkey -v
    export KEYTIMEOUT=1 # idk ?
    bindkey -v '^?' backward-delete-char # fix backspace
# Change directory by typing name
    setopt autocd
    alias '...'='cd ../../'
    alias '....'='cd ../../../'
    alias '.....'='cd ../../../../'
# Add `code` folder to cdpath
    # export CDPATH=$CDPATH:~/code
# Persistant history
    HISTFILE=~/.cache/zsh_history
    HISTSIZE=10000
    SAVEHIST=10000
    setopt SHARE_HISTORY
# Use case-insensitive autocompletions
    autoload -Uz compinit && compinit
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Share history with tmux ?

#========= ALIASES
# Tmux
    alias t='tmux'
    # alias tn='tmux -u new'
    alias ta='tmux -u attach'
# Exit (vim)
    alias q='exit'
    alias :q='exit'
    alias :wq='exit'
    alias Z='exit'
    alias ZZ='exit'
# Git
    alias g='git'
    alias ga='git add .'
    alias gc='git commit -m $1'
    alias gac='git add . && git commit -m $1'
    alias gp='git push'
    alias gd='git diff'
    alias gitignore='cat .gitignore'
# Nvim
    # Open folder in nvim, instead of new buffer
    v() { if [ "$1" ]; then nvim $1; else nvim .; fi }
    alias vim='nvim'
# Pacman
    alias p='pacman'
    alias sp='sudo pacman'
# Rust
    alias c='cargo'
    alias cr='cargo run'
    alias cb='cargo build'
    alias cc='cargo check'
    alias ct='cargo test'
    alias crr='cargo run --release'
    alias cbr='cargo build --release'
    alias cdoc='cargo doc --no-deps --open'
    alias cw='cargo watch'
    alias cwr='cargo watch -x run'
    alias cwt='cargo watch -x test'
    alias ci='cargo install --path .'
# Dotfile editing
    alias d.='cd ~/dotfiles'
    alias d.z='nvim ~/dotfiles/zsh/.zshrc'
    alias d.v='cd ~/dotfiles/nvim/.config/nvim           && nvim .'
    alias d.t='cd ~/dotfiles/tmux/.config/tmux/          && nvim tmux.conf'
    alias d.r='cd ~/dotfiles/ranger/.config/ranger       && nvim rc.conf'
    alias d.i='cd ~/dotfiles/i3/.config/i3               && nvim config'
    alias d.a='cd ~/dotfiles/alacritty/.config/alacritty && nvim alacritty.yml'
# Misc. Programs
    alias j='just'
    alias ls='exa -l'
    alias lsa='ls -a'
    alias open='xdg-open'
    alias clip='xclip -selection clipboard'
    alias wiki='wiki-tui'
    alias tree='ls -T'
    alias scim='sc-im'
    alias dol='setsid dolphin .'
    alias trs='tree-sitter'
    alias cat='bat'
    alias r='ranger'
    alias lw='librewolf'
    alias shck='shellcheck'
# Misc
    alias p8='ping 8.8.8.8 -c 10'
    alias copydir='pwd | clip'
    alias mkdir='mkdir -p'
    alias doas="echo -e \"\x1b[34mdoas I do:\x1b[0m \x1b[1msudo\x1b[0m\""
    alias G='garf'
    alias Gf='garf-find'
    alias Gfd='garf-find-date'

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

