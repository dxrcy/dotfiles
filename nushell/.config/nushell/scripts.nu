def colors [] {
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

def latex_compile [file: string] {
    # --shell-escape is required for some packages:
    # https://tex.stackexchange.com/questions/598818/how-can-i-enable-shell-escape
    pdflatex --shell-escape $"($file).tex"
}

def latex_watch [file: string] {
    let compile = {||
        latex_compile $file
    }

    if not ($"($file).tex" | path exists) {
        return
    }

    def try_open [] {
        if not ($"($file).tex" | path exists) {
            return
        }
        if (lsof -Fc $"($file).pdf" | sed -n 's/^c//p') != "zathura" {
            sh -c $"zathura '($file).pdf' >/dev/null 2>&1 &"
        }
    }

    try_open
    sleep 0.1sec
    do $compile
    try_open

    echo $"($file).tex"
        | entr -np env NO_NU=1 zsh -ci $"pdflatex-bibtex '($file)'"

    # watch -g $"($file).tex" . $compile
}
