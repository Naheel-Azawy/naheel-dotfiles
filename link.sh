#!/bin/bash
D="$1"
U="$2"
H="$3"

[ "$D" = "" ] && D=.
[ "$U" = "" ] && U=$USER
[ "$H" = "" ] && H=$HOME

function lnnn {
    rm -rf $2 2> /dev/null
    ln -s $1 $2
}

mkdir -p "$H/.config/dunst"
lnnn "$D/dunstrc" "$H/.config/dunst/dunstrc"

mkdir -p "$H/.config/feh"
lnnn "$D/feh-keys" "$H/.config/feh/keys"

mkdir -p "$H/.config/fish"
lnnn "$D/fish-config.fish" "$H/.config/fish/config.fish"

mkdir -p "$H/.config/fontconfig"
lnnn "$D/fonts.conf" "$H/.config/fontconfig/fonts.conf"

mkdir -p "$H/.config/i3"
lnnn "$D/i3.conf" "$H/.config/i3/config"

mkdir -p "$H/.config/i3blocks"
lnnn "$D/i3blocks.conf" "$H/.config/i3blocks/config"

mkdir -p "$H/.config/youtube-viewer"
lnnn "$D/youtube-viewer.conf" "$H/.config/youtube-viewer/youtube-viewer.conf"

mkdir -p "$H/.config/zathura"
lnnn "$D/zathurarc" "$H/.config/zathura/zathurarc"

lnnn "$D/compton.conf"   "$H/.config/compton.conf"
lnnn "$D/user-dirs.dirs" "$H/.config/user-dirs.dirs"
lnnn "$D/ranger"         "$H/.config/ranger"

lnnn "$D/bashrc.sh"    "$H/.bashrc"
lnnn "$D/profile"      "$H/.profile"
lnnn "$D/profile"      "$H/.bashrc_profile"
lnnn "$D/profile"      "$H/.xprofile"
lnnn "$D/xinitrc"      "$H/.xinitrc"
lnnn "$D/Xresources"   "$H/.Xresources"
lnnn "$D/tmux.conf"    "$H/.tmux.conf"
lnnn "$D/tmux"         "$H/.tmux"
lnnn "$D/spacemacs.el" "$H/.spacemacs"

mkdir -p "$H/.icons/default"
lnnn "$D/gtk-theme/icons.theme" "$H/.icons/default/index.theme"

mkdir -p "$H/.config/gtk-3.0"
lnnn "$D/gtk-theme/gtk3-settings.ini" "$H/.config/gtk-3.0/settings.ini"

lnnn "$D/gtk-theme/gtk2rc" "$H/.gtkrc-2.0"
