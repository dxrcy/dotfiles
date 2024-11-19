export ZSHLVL=0

[ -f "$HOME/.profile" ] && . "$HOME/.profile"

dunst &
sxhkd &
windscribe &

touch "$HOME/.local/share/wm-init"

# Secrets
dbus-update-activation-environment --systemd DISPLAY
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

exec bspwm

