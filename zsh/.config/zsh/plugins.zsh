#!/bin/zsh

ZSH_PLUGIN_DIR="$HOME/.local/share/zsh" # Where to download plugins to

# Each item is the zsh entry file of plugin, relative to `$ZSH_PLUGIN_DIR`
ZSH_PLUGINS=(
    zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh
    zsh-users/zsh-history-substring-search/zsh-history-substring-search.zsh
    # hlissner/zsh-autopair/zsh-autopair.plugin.zsh
)

_zsh_warn()  { _zsh_diagnostic '2;33' $* }
_zsh_error() { _zsh_diagnostic '2;31' $* }
_zsh_diagnostic() {
    local color="$1"
    local fmt="$2"
    shift 2
    printf "\x1b[${color}mzsh: $fmt\x1b[0m\n" $*
}

zsh-plugins-init() {
    zsh-plugins-load
}

zsh-plugins-load() {
    zsh-plugins-ensure-dir

    # Source each entry file
    local filepath
    for filepath in $ZSH_PLUGINS; do
        if [ ! -e "$ZSH_PLUGIN_DIR/$filepath" ]; then
            _zsh_warn "cannot find plugin file '%s'; perhaps it is not installed." "$filepath"
            continue
        fi
        source "$ZSH_PLUGIN_DIR/$filepath"
    done

    # Settings for plugins
    # Will not be applied if plugins installation is interrupted
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=15'
    bindkey '^[[A'       history-substring-search-up
    bindkey '^[[B'       history-substring-search-down
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
    HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
}

zsh-plugins-install() {
    zsh-plugins-ensure-dir

    local filepath
    for filepath in $ZSH_PLUGINS; do
        local plugin="${filepath%/*}" # Remove filename from path

        if [ ! -d "$ZSH_PLUGIN_DIR/$plugin" ]; then # Check if not installed
            _zsh_warn "installing '%s'..." "$plugin"
            if ! git clone --quiet "https://github.com/$plugin" "$ZSH_PLUGIN_DIR/$plugin"; then
                _zsh_error "failed to download plugin '%s'."
                continue
            fi
        fi
    done
}

zsh-plugins-clean() {
    zsh-plugins-ensure-dir

    local dir_full
    local found
    local filepath
    for dir_full in $ZSH_PLUGIN_DIR/*/*(N); do # List all installed plugins
        local dir=${dir_full#$ZSH_PLUGIN_DIR/} # Remove pkgdir from path

        unset found
        for filepath in $ZSH_PLUGINS; do # Check if plugin is in list
            local plugin="${filepath%/*}" # Remove filename from path
            if [ "$plugin" = "$dir" ]; then
                found=1
                break
            fi
        done

        if [ -z "$found" ]; then # Remove if not in list
            _zsh_warn "removing old plugin '%s'..." "$dir"
            rm -rf "$dir_full"
        fi
    done

    # Clean parent directories
    local author_full
    for author_full in $ZSH_PLUGIN_DIR/*(N); do
        if [ -z "$(\ls "$author_full")" ]; then
            rm -r "$author_full"
        fi
    done
}

zsh-plugins-ensure-dir() {
    if [ ! -e "$ZSH_PLUGIN_DIR" ]; then
        mkdir -p "$ZSH_PLUGIN_DIR"
    fi
    if [ ! -d "$ZSH_PLUGIN_DIR" ] || [ ! -w "$ZSH_PLUGIN_DIR" ]; then
        _zsh_error "cannot access plugin directory at '%s'." "$ZSH_PLUGIN_DIR"
        return 1
    fi
}
