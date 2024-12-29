#!/bin/sh

logfile="$HOME/monitor-fix.log"

echo >> "$logfile"
printf '@@@ ' >> "$logfile"
date -Iseconds >> "$logfile"

log() {
    echo >> "$logfile"
    echo "@ $@" >> "$logfile"
    $@ 2>&1 >> "$logfile"
}

log hyprctl keyword monitor disable

sleep 1

log hyprctl keyword monitor eDP-1,preferred,auto,1.6666667

sleep 1

log hyprctl keyword monitor ,disable

sleep 1

log hyprctl keyword monitor ,enable

wpaperd -d

