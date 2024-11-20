# XDG base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# XDG user directories
. "$XDG_CONFIG_HOME"/user-dirs.dirs

# Use XDG base directories
export CABAL_CONFIG="$XDG_CONFIG_HOME"/cabal/config
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup

. "$CARGO_HOME/env"

# Merge xresources if the file exists
if [ -f $XDG_CONFIG_HOME/x11/Xresources ]; then
  xrdb -merge $XDG_CONFIG_HOME/x11/Xresources
fi

# Default applications
export TERMINAL=kitty
export EDITOR=nvim
export BROWSER=zen-browser

# Theme
# Idk if this even works...
export GTK_THEME=Arc-Dark
# export GTK_THEME=Adwaita:dark

# Zig version manager
export ZVM_INSTALL="$HOME/.zvm/self"
export PATH="$PATH:$HOME/.zvm/bin"
export PATH="$PATH:$ZVM_INSTALL/"

# export XDG_CURRENT_DESKTOP=GTK
# export GTK_USE_PORTAL=1

#----------------------------------------------------
# If you're trying to set dark mode, try this command
# Do not leave in ~/.profile !!
#--> xfconf-query -c xsettings -p /Net/ThemeName -s Adwaita-dark
#----------------------------------------------------

#----------------------------------------------------
# Everything below: does not work (for some reason)!
#----------------------------------------------------

# Theme properties
# xprop -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT "dark"
# export GTK_THEME=:dark
# export GTK_THEME_VARIANT="dark"

# Some tips from here:
# https://wiki.archlinux.org/title/Uniform_look_for_Qt_and_GTK_applications#Flatpak_Qt_apps_do_not_use_Gnome_Adwaita_dark_theme
# export QT_QPA_PLATFORMTHEME='gnome'
# export QT_QPA_PLATFORMTHEME=gtk2


if [ -e /home/darcy/.nix-profile/etc/profile.d/nix.sh ]; then . /home/darcy/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
