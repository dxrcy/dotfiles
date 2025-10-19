#!/bin/zsh
#-------------------------------------------------------------------------------
# Misc

zsh-reload-config() {
    unalias -a
    ZSHLVL_NOINC=1 source ~/.zshrc
}

abandon() {
    eval $* & disown
}
abandon-exit() {
    eval $* & disown
    exit
}

# Open directory in nvim, instead of new buffer
nvim-dir() {
    if [ "$*" ];
        then \nvim $*
        else \nvim .
    fi
}

project-setup() {
    local file='./.project-setup'
    [ -x "$file" ] && "$file"
}

#-------------------------------------------------------------------------------
# Navigation

# Make directory and cd
mkdir-cd() {
    mkdir -p $* && cd $*
}

# Use `yazi` to `cd`, without spawning subshell
# https://yazi-rs.github.io/docs/quick-start
yazi-cd() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	\yazi "$@" --cwd-file="$tmp"
	IFS='' read -r -d '' cwd < "$tmp"
	if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
	rm -f -- "$tmp"
}

#-------------------------------------------------------------------------------
# Navigation - fzf to locations

fzf-cd-setup() {
    local dir=$(fzf-dir $*)
    [ -n "$dir" ] || return
    cd -- "$dir"
    project-setup
}

fzf-project() {
    # TODO: Move directory definition
    fzf-cd-setup 2 ~/.projects
}
fzf-sandbox() {
    # TODO: Move directory definition
    fzf-cd-setup 1 ~/code/sandbox
}

#-------------------------------------------------------------------------------
# Git/GitHub

# GitHub url shorthand
gh-url() {
    local url="$1"
    case "$url" in
        '') return 1 ;;
        @*) echo "$GH/${url:1}" ;;
        :*) echo "$GHU/${url:1}" ;;
         *) echo "$url" ;;
     esac
}

# Git clone alias with URL shorthand, and cd
git-clone-cd() {
    # TODO: Make better
    local url="$(gh-url $1)" || { git clone ; return $?; }
    shift
    git clone "$url" $* || return $?
    local target="$1" # Target directory argument, or use URL path
    if [ -z "$target" ]; then
        # Extract repository name from url
        target="$(echo "$url" \
            | sed 's|/$||' \
            | sed 's|\.git$||' \
            | sed 's|^.*/||'\
        )"
    fi
    cd "./$target"
}

gh-switch() {
    local account
    if git config --get 'user.email' 'student' >/dev/null;
        then account="$GH_STUDENT"
        else account="$GH_MAIN"
    fi
    gh auth switch -u "$account"
}

#-------------------------------------------------------------------------------
# Latex

pdflatex-bibtex() {
    local custom='./compile.sh'
    local file="$1"
    if [ -f "$custom" ]; then
        "$custom" || return $?
    fi
    if [ -f "$file.bib" ]; then
        pdflatex --shell-escape -draftmode "$file.tex" || return $?
        bibtex "$file" || return $?
        pdflatex --shell-escape -draftmode "$file.tex" || return $?
    fi
    pdflatex --shell-escape "$file.tex" || return $?
}

pdflatex-watch() {
    local compile='pdflatex-bibtex'
    local file="$1"

    if [ ! -f "$file.tex" ]; then
        echo 'no file found'
        return 1
    fi

    local try-open() {
        if [ -f "$file.pdf" ] && [ ! "$(lsof -Fc "$file.pdf" | sed -n 's/^c//p')" = 'zathura' ]; then
            zathura "$file.pdf" & disown
        fi
    }

    try-open
    sleep 0.1
    "$compile" "$file"
    try-open
    {
        printf "$file.tex\n$file.bib"
        \find assets
    } | entr -np zsh -ci "$compile '$file'"
}

latex-clean() {
    local file="$1"
    if [ -z "$file" ] || [ ! -f "$file.tex" ]; then
        echo "latex-clean: no tex file found" >&2
        return 1
    fi
    trash "$file-blx.bib" 2>/dev/null
    trash "$file.aux"     2>/dev/null
    trash "$file.bbl"     2>/dev/null
    trash "$file.bcf"     2>/dev/null
    trash "$file.blg"     2>/dev/null
    trash "$file.blg"     2>/dev/null
    trash "$file.log"     2>/dev/null
    trash "$file.out"     2>/dev/null
    trash "$file.run.xml" 2>/dev/null
}

