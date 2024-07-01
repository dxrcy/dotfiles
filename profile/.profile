# GTK_USE_PORTAL=1

# Merge xresources if the file exists
if [ -f ~/.Xresources ]; then
  xrdb -merge ~/.Xresources
fi

export TERMINAL=kitty

# XDG base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Use XDG base directories
export CABAL_CONFIG="$XDG_CONFIG_HOME"/cabal/config
export CARGO_HOME="$XDG_DATA_HOME"/cargo

. "$CARGO_HOME/env"

# export GTK_THEME=Adwaita:dark
export GTK_THEME=Arc-Dark

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

# ZVM
export ZVM_INSTALL="$HOME/.zvm/self"
export PATH="$PATH:$HOME/.zvm/bin"
export PATH="$PATH:$ZVM_INSTALL/"

