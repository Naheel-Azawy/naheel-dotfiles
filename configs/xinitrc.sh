#!/bin/sh

#export WINDOW_MANAGER='i3'
export WINDOW_MANAGER='bspwm'
#export WINDOW_MANAGER='emacs'
#export WINDOW_MANAGER='gnome-session'

export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11

export FONT_MONO='Iosevka Fixed'
export FONT_SANS='Liberation Sans'
export FONT="$FONT_MONO"
export GTK_THEME="Adwaita:dark"
export DESKTOP_SESSION=gnome
export QT_QPA_PLATFORMTHEME="qt5ct"
#export QT_DEVICE_PIXEL_RATIO=1
export QT_AUTO_SCREEN_SCALE_FACTOR=0
#export QT_STYLE_OVERRIDE=adwaita-dark
export CM_LAUNCHER=menus-face # for clipmenu

userresources=$HOME/.Xresources
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# add env vars to xrdb
[ "$FONT" ] &&
    xrdb() { command xrdb -DFONT="$FONT" "$@"; }

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# start the system keyring
eval "$(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)"
export SSH_AUTH_SOCK

# enable the HUD menu
eval "$(menus hud env)"

# logs dir
logdir="/tmp/xinitlogs-$USER"
mkdir -p "$logdir"
rm -r "$logdir"/*

autostart() {
    [ "$WINDOW_MANAGER" = 'gnome-session' ] &&
        return
    d=$(date)
    if command -v "$1" >/dev/null; then
        echo "$d: STDOUT OF" "$@" > "$logdir/$1"
        echo "$d: STDERR OF" "$@" > "$logdir/$1-err"
        "$@" >> "$logdir/$1" 2>> "$logdir/$1-err" &
    else
        echo "$1 not found!!!" > "$logdir/$1-err"
    fi
}

export SXHKD_SHELL=dash

# autostart programs
autostart thinkpadutils trackpoint      # set trackpoint speed
autostart sxhkd                         # keyboard daemon
autostart ndots-gui lang init           # set the keyboard layouts
autostart bar                           # top bar
autostart wttr daemon                   # weather update
autostart dunst                         # notifications daemon
autostart clipmenud                     # clipboard manager daemon
autostart ndots-gui input daemon        # mouse and keyboard setup
autostart xbanish                       # hides the cursor while typing
autostart syndaemon -i 0.5 -t -K -R     # disable touchpad while typing
autostart edit daemon                   # emacs daemon
autostart picom --experimental-backends # compositor
autostart ndots-gui wallpaper reset     # wallpaper
autostart automon daemon                # automatic monitor config
autostart automon auto                  # set monitors
autostart lang us                       # set language to 'us' and runs xmodmap
autostart fmz --mount-monitor           # automatically mount drives
autostart mount-private                 # mount encfs private directory
#autostart menus hud daemon              # hud menu daemon
autostart nm-applet                     # network applet
autostart blueman-applet                # bluetooth applet

# start the window manager
exec "$WINDOW_MANAGER" # defined in profile
