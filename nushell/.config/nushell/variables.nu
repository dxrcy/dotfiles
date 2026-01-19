$env.config.show_banner = false
$env.config.rm.always_trash = true
$env.config.buffer_editor = "nvim"

$env.config.table.index_mode = "auto"
$env.config.table.mode = "compact"

$env.config.datetime_format = {
    normal: "%a %d %b %Y %H:%M:S %z"
    table: "%F %T"
}

# $env.config.history.sync_on_enter = false
$env.config.history.file_format = "sqlite"
# $env.config.history.isolation = true

$env.config.completions.algorithm = "fuzzy"

$env.config.cursor_shape = {
    vi_insert: "line"
    vi_normal: "block"
}

$env.config.edit_mode = "vi"

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
let CBU = $"($CB):($CB_MAIN)"

