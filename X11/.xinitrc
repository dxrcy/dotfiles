export ZSHLVL=0

[ -f "$HOME/.profile" ] && . "$HOME/.profile"

dunst &
sxhkd &
windscribe &

touch "$HOME/.local/share/wm-init"

# exec i3
exec bspwm

