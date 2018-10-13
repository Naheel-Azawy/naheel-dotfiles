#!/bin/sh

# Profile file. Runs on login.

export EDITOR="x"
export VISUAL="$EDITOR"
export TERMINAL="st"
export BROWSER="browser"
export READER="evince"
export BIB="$HOME/Documents/LaTeX/refs.bib"

export GTK_THEME="Adwaita:dark"
export DESKTOP_SESSION=gnome
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_DEVICE_PIXEL_RATIO=1
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_STYLE_OVERRIDE=adwaita-dark
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'

export PI=3.14159265358979323844
export EU=2.71828182845904523537

[[ -f ~/.dotfiles-exports ]] && . ~/.dotfiles-exports
[[ -f ~/.more-paths ]] && . ~/.more-paths
[[ -f ~/.bashrc ]] && . ~/.bashrc

# To be able to change the brightness. Password is not required as edited in the sudoers
sudo chmod a+rw /sys/class/backlight/intel_backlight/brightness

# Start graphical server if i3 not already running.
if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep -x i3 || exec startx
fi


