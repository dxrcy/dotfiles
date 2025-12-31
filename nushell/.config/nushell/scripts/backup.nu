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

