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

