#!/bin/sh

# Profile file. Runs on login.

export EDITOR="x"
export VISUAL="$EDITOR"
export TERMINAL="st"
export BROWSER="browser"
export READER="zathura"
export BIB="$HOME/Documents/LaTeX/refs.bib"

export FONT_MONO='DejaVu Sans Mono'
export FONT_SANS='Liberation Sans'
export FONT="$FONT_MONO"
export GTK_THEME="Adwaita:dark"
export DESKTOP_SESSION=gnome
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_DEVICE_PIXEL_RATIO=1
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export QT_STYLE_OVERRIDE=adwaita-dark
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'
export CLOUDCONVERT_API_KEY='bUGujVfvGQ6nkPZo5MvFoIz65C3spOZMtiD4Bz613XxnXsUIVDDwZILqOJZghP3D'

export PI=3.14159265358979323844
export EU=2.71828182845904523537

export I3BLOCKS_DUR_TIME='1'
export I3BLOCKS_DUR_BATT='1'
export I3BLOCKS_DUR_WIFI='5'
export I3BLOCKS_DUR_BRIG='once'
export I3BLOCKS_DUR_VOLU='once'
export I3BLOCKS_DUR_SENS='3'
export I3BLOCKS_DUR_WEAT='1800'
export I3BLOCKS_DUR_PRAY='10'
export I3BLOCKS_DUR_LANG='once'

export I3BLOCKS_SIG_TIME=1
export I3BLOCKS_SIG_BATT=2
export I3BLOCKS_SIG_WIFI=3
export I3BLOCKS_SIG_BRIG=4
export I3BLOCKS_SIG_VOLU=5
export I3BLOCKS_SIG_SENS=6
export I3BLOCKS_SIG_WEAT=7
export I3BLOCKS_SIG_PRAY=8
export I3BLOCKS_SIG_LANG=9
export I3BLOCKS_SIG_FIRS=$I3BLOCKS_SIG_TIME
export I3BLOCKS_SIG_LAST=$I3BLOCKS_SIG_LANG

[[ -f ~/.dotfiles-exports ]] && . ~/.dotfiles-exports
[[ -f ~/.more-paths ]]       && . ~/.more-paths
[[ -f ~/.bashrc ]]           && . ~/.bashrc

# To be able to change the brightness. Password is not required as edited in the sudoers
sudo chmod a+rw /sys/class/backlight/intel_backlight/brightness

# Start graphical server if i3 not already running.
if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep -x i3 || exec startx
fi

