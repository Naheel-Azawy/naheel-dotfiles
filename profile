#!/bin/sh

# Profile file. Runs on login.

export EDITOR="emar"
export VISUAL="$EDITOR"
export TERMINAL="st"
export BROWSER="browser"
export READER="evince"
export GTK_THEME="Adwaita:dark"

export PI=3.14159265358979323844
export EU=2.71828182845904523537

export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_DEVICE_PIXEL_RATIO=1

[[ -f ~/.dotfiles-exports ]] && . ~/.dotfiles-exports

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Start graphical server if i3 not already running.
if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep -x i3 || exec startx
fi


