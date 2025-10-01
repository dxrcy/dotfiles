#!/bin/sh

printf '<span line_height="1.5em">'
echo "$(date +'%H:%M')"
echo "$(date +'%Y-%m-%d')"
echo "$(battery-info)"
printf '</span>'

