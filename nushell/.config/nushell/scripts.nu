def colors []: nothing -> nothing {
    let bgs1 = [ 49 40 41 42 43 44 45 46 47 ]
    let bgs2 = [    40 41 42 43 44 45 46 47 ]
    let fgs  = [    30 31 32 33 34 35 36 37 ]
    let offsets = [ 0 60 ]

    for bg in $bgs1 {
        for it in ($offsets | enumerate) {
            let offset = $it.item

            if $it.index > 0 {
                print -n "  "
            }

            for fg in $fgs {
                print -n (ansi -e $"($bg + $offset)m")
                print -n (ansi -e $"($fg + $offset)m")
                print -n "* "
            }

            print -n (ansi reset)
        }

        print ""
    }
    print ""

    for offset in $offsets {
        for bg in $bgs2 {
            print -n $"(ansi -e $"($bg + $offset)m")"
            print -n "   "
        }

        print -n (ansi reset)
        print ""
    }
    print ""

    print -n "Normal"
    print -n (ansi default_bold)
    print -n "    Bold"
    print -n (ansi reset)
    print ""

    print -n (ansi default_italic)
    print -n "Italic"
    print -n (ansi default_bold)
    print -n " BoldItalic"
    print -n (ansi reset)
    print ""
}

def latex_compile [file: string]: nothing -> nothing {
    # --shell-escape is required for some packages:
    # https://tex.stackexchange.com/questions/598818/how-can-i-enable-shell-escape
    echo | pdflatex --shell-escape $"($file).tex"
}

def latex_watch [file: string]: nothing -> nothing {
    let compile = {||
        let result = (latex_compile $file | complete)
        print $result.stdout
        if $result.exit_code != 0 {
            print $"(ansi red)--- FAILED ---(ansi reset)"
        }
    }

    if not ($"($file).tex" | path exists) {
        return
    }

    def try_open_pdf [] {
        if not ($"($file).tex" | path exists) {
            return
        }
        if (lsof -Fc $"($file).pdf" | sed -n 's/^c//p') != "zathura" {
            sh -c $"zathura '($file).pdf' >/dev/null 2>&1 &"
        }
    }

    try_open_pdf
    sleep 0.1sec
    do $compile
    try_open_pdf

    watch --quiet --glob $"($file).tex" . $compile
}

# Backup a file to a global or local directory
def backup [
    --local (-l), # Use local backup destination (sibling of $file)
    --move (-m),  # Move $file instead of copying
    file: string, # File to backup
]: nothing -> nothing {
    let parent = ($file | path expand | path dirname)

    let location = if $local {
        ($parent)/.backup
    } else {
        ($env.XDG_DATA_HOME? | default ($env.HOME)/.local/share)/backup
    }

    let origin = ($parent | str replace --all "/" "%")
    let timecode = (date now | format date "%Y-%m-%d-%H%M")
    let dest = ($location)/($origin)/($timecode)

    mkdir $dest

    if $move {
        (mv $file $dest
            --progress
        )
    } else {
        (cp $file $dest
            --recursive
            --progress
            --preserve [ mode ownership timestamps context link links xattr ]
        )
    }
}

