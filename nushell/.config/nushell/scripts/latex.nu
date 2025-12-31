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
