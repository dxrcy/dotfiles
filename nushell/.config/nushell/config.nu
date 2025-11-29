#------------------------------------------------------------------------------#
#                       * Blazingly fast Nushell config *                      #
#------------------------------------------------------------------------------#

$env.config.show_banner = false
$env.config.rm.always_trash = true
$env.config.buffer_editor = "nvim"

$env.config.edit_mode = "vi"
$env.config.cursor_shape.vi_insert = "line"
$env.config.cursor_shape.vi_normal = "block"

#-------------------------------------------------------------------------------
# KEYBINDINGS

$env.config.keybindings ++= [ {
    modifier: none
    keycode: Char__
    mode: [vi_normal]
    event: { edit: MoveToStart }
} ]

# Disable Ctrl-D
$env.config.keybindings ++= [ {
    modifier: CONTROL
    keycode: Char_d
    mode: [emacs, vi_insert, vi_normal]
    event: null
} ]

#-------------------------------------------------------------------------------
# MISC

source ~/.zoxide.nu

#-------------------------------------------------------------------------------
# FUNCTIONS

def --wrapped nvim_dir [...args] {
    if ($args | length) > 0 {
        ^nvim ...$args
    } else {
        ^nvim .
    }
}

def --env mkdir_cd [dir] {
    ^mkdir $dir
    cd $dir
}

def --env yazi_cd [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    ^yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp)
    if $cwd != "" and $cwd != $env.PWD {
        cd $cwd
    }
    rm -fp $tmp
}

#-------------------------------------------------------------------------------
# ALIASES

alias grep = rg

alias nvim = nvim_dir
alias mkd = mkdir_cd
alias yazi = yazi_cd

alias p = pacman-thing

alias lsa = ls -a

alias vim = nvim
alias v = nvim
alias r = yazi
alias wcl = wc -l
alias wlc = wl-copy

alias    q = exit
alias  \:q = exit
alias \:wq = exit
alias    ŝ = exit
alias  \:ŝ = exit
alias \:ĝŝ = exit

alias dc = cd -

alias zig = ~/.zvm/bin/zig

#-------------------------------------------------------------------------------
# PROMPT

def pwd_last_parts [] {
    pwd | str replace $env.HOME "~"
        | path split
        | last 3
        | str join "/"
        | str replace -r "/+" "/"
}

def prompt_left [] {
    print -n (ansi yellow_bold)
    print -n (pwd_last_parts)
    print ""
}

$env.PROMPT_COMMAND = { prompt_left }
$env.PROMPT_COMMAND_RIGHT = { null }
$env.PROMPT_INDICATOR           = $"(ansi yellow)> "
$env.PROMPT_INDICATOR_VI_INSERT = $"(ansi yellow): "
$env.PROMPT_INDICATOR_VI_NORMAL = $"(ansi yellow)> "

