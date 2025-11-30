#!/bin/zsh
#------------------------------------------------------------------------------#
#                         * Blazingly fast Zsh config *                        #
#------------------------------------------------------------------------------#

# TODO: Fix $ZSHLVL

# Source ~/.profile in any tty
if [ -z "$DISPLAY" ]; then
    [ -f "$HOME/.profile" ] && . "$HOME/.profile"
    # Explicitly source XDG base directories (in case .profile fails)
    [ -f "$HOME/.config/user-dirs.dirs" ] && . "$HOME/.config/user-dirs.dirs"
fi

ZSH_CONFIG_DIR="$XDG_CONFIG_HOME/zsh"

# Order is important!
source "$ZSH_CONFIG_DIR/variables.zsh"
source "$ZSH_CONFIG_DIR/misc.zsh"
source "$ZSH_CONFIG_DIR/functions.zsh"
source "$ZSH_CONFIG_DIR/aliases.zsh"
source "$ZSH_CONFIG_DIR/keybinds.zsh"
source "$ZSH_CONFIG_DIR/prompt.zsh"
source "$ZSH_CONFIG_DIR/plugins.zsh"

zsh-plugins-init # plugins.zsh
zsh-start-desktop # misc.zsh

true # Reset $? for prompt

# TEMPORARY
exec nu

