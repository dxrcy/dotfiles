export ZSHLVL=0

[ -f "$HOME/.profile" ] && . "$HOME/.profile"

dunst &
sxhkd &
windscribe &

# exec i3
exec bspwm

