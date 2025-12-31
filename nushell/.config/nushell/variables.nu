$env.config.show_banner = false
$env.config.rm.always_trash = true
$env.config.buffer_editor = "nvim"

$env.config.edit_mode = "vi"
$env.config.cursor_shape.vi_insert = "line"
$env.config.cursor_shape.vi_normal = "block"

$env.DESKTOP = "hyprland"
$env.DESKTOP_TTY = "/dev/tty1"

# https://github.com/nushell/nushell/issues/17265
try { $env.config.auto_cd_always = true }

# GitHub shorthand variables
let GH = "https://github.com"
let GH_MAIN = "dxrcy"
let GH_STUDENT = "dyrcyuni"
let GHU = $"($GH)/($GH_MAIN)"
# Codeberg shorthand variables
let CB = "git@codeberg.org"
let CB_MAIN = "dxrcy"
let CBU = $"($CB)/($CB_MAIN)"

