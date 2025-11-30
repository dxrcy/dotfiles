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

def --env project_setup [] {
    let file = '.project-setup'
    if ($file | path exists) {
        sh $file
    }
}

def --env fzf_cd_setup [...args] {
    let dir = (sh fzf-dir ...$args)
    cd $dir
    project_setup
}

def --env fzf_sandbox [] {
    fzf_cd_setup 1 $"($env.HOME)/code/sandbox"
}

