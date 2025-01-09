#!/bin/sh

logfile="$HOME/.cache/monitor-fix.log"
delay=1

echo >> "$logfile"
printf '@@@ ' >> "$logfile"
date -Iseconds >> "$logfile"

log() {
    echo >> "$logfile"
    echo "@ $@" >> "$logfile"
    $@ 2>&1 >> "$logfile"
}

log hyprctl keyword monitor eDP-1,disable

sleep "$delay"

log hyprctl keyword monitor eDP-1,preferred,auto,1.6666667

sleep "$delay"

log hyprctl keyword monitor ,disable

sleep "$delay"

log hyprctl keyword monitor ,enable

wpaperd -d

