#!/bin/sh

if pidof hypridle; then
    killall hypridle
else
    hypridle & disown
fi

