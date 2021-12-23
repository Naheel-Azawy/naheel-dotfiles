#!/bin/sh

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

# autostart programs
env SXHKD_SHELL=dash sxhkd &    # keyboard daemon
lang init &                     # set the keyboard layouts
bar lemon &                     # top bar
wttr daemon &                   # weather update
dunst &                         # notifications daemon
clipmenud &                     # clipboard manager daemon
setup-xinput &                  # mouse and keyboard setup
xbanish &                       # hides the cursor while typing
syndaemon -i 0.5 -t -K -R &     # disable touchpad while typing
edit daemon &                   # emacs daemon
picom --experimental-backends & # compositor
setwallpaper &                  # wallpaper
automon &                       # automatic monitor config
lang us &                       # set language to 'us' and runs xmodmap
fmz --mount-monitor &           # automatically mount drives
mount-private &                 # mount encfs private directory
#menus hud daemon &              # hud menu daemon

# start the window manager
exec "$WINDOW_MANAGER" # defined in profile
