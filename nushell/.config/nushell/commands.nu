# Terrible hack
def --wrapped abandon [
    --quiet (-q),
    cmd: string,
    ...args: string,
]: nothing -> nothing {
    let cmdline = $cmd + " " + ($args | str join " ")
    let redirect = if $quiet {
        $" o+e> /dev/null"
    } else {
        ""
    }
    sh -c $"nu -c '($cmdline) ($redirect)' & disown"
}

def --wrapped nvim_dir [...args: string]: nothing -> nothing {
    if ($args | length) > 0 {
        ^nvim ...$args
    } else {
        ^nvim .
    }
}

def --env mkdir_cd [dir: string]: nothing -> nothing {
    let dir = ($dir | into string)
    ^mkdir $dir
    cd $dir
}

def --env yazi_cd [...args: string]: nothing -> nothing {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    ^yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp)
    if $cwd != "" and $cwd != $env.PWD {
        cd $cwd
    }
    rm -fp $tmp
}

def --env project_setup []: nothing -> nothing {
    let file = '.project-setup'
    if ($file | path exists) {
        sh $file
    }
}

def --env fzf_cd_setup [...args: string]: nothing -> nothing {
    let dir = (sh fzf-dir ...$args)
    cd $dir
    project_setup
}

def --env fzf_sandbox []: nothing -> nothing {
    fzf_cd_setup 1 $"($env.HOME)/code/sandbox"
}

def git_provider_url [
    domain: string,
    user: string,
    name: string,
]: nothing -> string {
    let prefix = ($name | str substring 0..0)
    let rest = ($name | str substring 1..)
    match $prefix {
        : => $"($domain)/($user)/($rest)"
        @ => $"($domain)/($rest)"
        _ => $name
    }
}

def github_url [name: string]: nothing -> string {
    git_provider_url $GH $GH_MAIN $name
}
def codeberg_url [name: string]: nothing -> string {
    git_provider_url $CB $CB_MAIN $name
}

def extract_url_repo_name [url: string]: nothing -> string {
    $url
        | path split
        | last
        | str replace --regex '\.git$' ""
}

def --env --wrapped git_clone_cd [
    name: string,
    target?: string,
    ...options: string,
]: nothing -> nothing {
    let url = (github_url $name)
    let target = if $target != null { $target } else {
        (extract_url_repo_name $url)
    }

    git clone $url $target ...$options
    cd $target
}

def github_switch []: nothing -> nothing {
    let result = (git config --get "user.email" "student" | complete)
    let account = if $result.exit_code == 0 {
        $GH_STUDENT
    } else {
        $GH_MAIN
    }
    gh auth switch -u $account
}

