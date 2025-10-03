#!/bin/zsh
#-------------------------------------------------------------------------------
# Renames

# Misc. alternative programs
alias cat='bat'
alias find='fd'
alias grep="rg"
alias z='zi'

# Custom functions
alias zr='zsh-reload-config'
alias ,='abandon'
alias ,,='abandon-exit'
alias nvim='nvim-dir'
alias mkd='mkdir-cd'
alias yazi='yazi-cd'
alias pj='fzf-project'
alias s='fzf-sandbox'
alias pjs='project-setup'
alias ghu='gh-url'
alias gcl='git-clone-cd'
alias ghs='gh-switch'

# Custom scripts
alias p='pacman-thing'

#-------------------------------------------------------------------------------
# Options

# Misc. program defaults (not alternative programs)
alias mkdir='mkdir -p'
alias cp='cp -r'
alias swiv='swiv -a -B#000000'
alias gcc='gcc -Wall -Wpedantic'
alias journalctl='journalctl -e'

# ls (eza) options
alias ls='eza -l --group-directories-first'
alias lsa='ls -a'
alias lst='ls --total-size --sort size --reverse'

# Open in pager/editor
alias pstree='pstree -U | less'
alias zh='vim + ~/.cache/zsh_history'

#-------------------------------------------------------------------------------
# Abbreviations / mispellings

# Misc
alias vim='nvim'
alias v='nvim'
alias wcl='wc -l'
alias m='make'
alias r='yazi'
alias sy='systemctl'
alias ssy='sudo systemctl'
alias syu='systemctl --user'
alias btc='bluetoothctl'
alias bhs='basic-http-server'
alias wlc='wl-copy'
alias print='printf' # Prevent terrible problems!

# Exit (vim habit)
alias   q='exit'
alias  :q='exit'
alias :wq='exit'
alias   ŝ='exit'
alias  :ŝ='exit'
alias :ĝŝ='exit'

#-------------------------------------------------------------------------------
# Other

# `$ command` runs `command`
\$() { $* }

# If last command was meant to be cd
alias ll='cd !!'

# Reverse previous `cd`
alias dc='cd - >/dev/null'

# Custom command locations
alias zig='~/.zvm/bin/zig'

# Dotfile editing
alias .z='cd ~/dotfiles/zsh                   && nvim .zshrc'
alias .v='cd ~/dotfiles/nvim/.config/nvim     && nvim .'
alias .h='cd ~/dotfiles/hyprland/.config/hypr && nvim hyprland.conf'

# Matches AUTOCD
alias   ...='cd ../../'
alias  ....='cd ../../../'
alias .....='cd ../../../../'

