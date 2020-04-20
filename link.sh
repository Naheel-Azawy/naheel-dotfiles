#!/bin/sh
D="$1"
U="$2"
H="$3"

[ "$D" = "" ] && D="$DOTFILES_DIR"
[ "$D" = "" ] && D=$(pwd)
[ "$U" = "" ] && U="$USER"
[ "$H" = "" ] && H="$HOME"

lnnn() {
    TODIR=$(dirname "$2")
    mkdir -p "$TODIR"
    rm -rf "$2" 2> /dev/null
    ln -s "$1" "$2"
}

lnnn "$D/configs/dunstrc"             "$H/.config/dunst/dunstrc"
lnnn "$D/configs/fish-config.fish"    "$H/.config/fish/config.fish"
lnnn "$D/configs/fonts.conf"          "$H/.config/fontconfig/fonts.conf"
lnnn "$D/configs/youtube-viewer.conf" "$H/.config/youtube-viewer/youtube-viewer.conf"
lnnn "$D/configs/mpd.conf"            "$H/.config/mpd/mpd.conf"
lnnn "$D/configs/ncmpcpp.conf"        "$H/.config/ncmpcpp/config"
lnnn "$D/configs/zathurarc"           "$H/.config/zathura/zathurarc"
lnnn "$D/configs/lfrc.sh"             "$H/.config/lf/lfrc"
lnnn "$D/configs/sxiv-key-handler.sh" "$H/.config/sxiv/exec/key-handler"
lnnn "$D/configs/sxiv-image-info.sh"  "$H/.config/sxiv/exec/image-info"
lnnn "$D/configs/compton.conf"        "$H/.config/compton.conf"
lnnn "$D/configs/user-dirs.dirs"      "$H/.config/user-dirs.dirs"
lnnn "$D/configs/mednafen.cfg"        "$H/.mednafen/mednafen.cfg"
lnnn "$D/configs/bashrc.sh"           "$H/.bashrc"
lnnn "$D/configs/profile"             "$H/.profile"
lnnn "$D/configs/profile"             "$H/.bashrc_profile"
lnnn "$D/configs/profile"             "$H/.xprofile"
lnnn "$D/configs/xinitrc.sh"          "$H/.xinitrc"
lnnn "$D/configs/Xresources"          "$H/.Xresources"
lnnn "$D/configs/Xmodmap"             "$H/.Xmodmap"
lnnn "$D/configs/tmux.conf"           "$H/.tmux.conf"
lnnn "$D/configs/emacs-init.el"       "$H/.emacs"
lnnn "$D/configs/more-paths.sh"       "$H/.more-paths"
lnnn "$D/configs/nm-dmenu.ini"        "$H/.config/networkmanager-dmenu/config.ini"
lnnn "$D/configs/gtk-icons.theme"     "$H/.icons/default/index.theme"
lnnn "$D/configs/gtk3-settings.ini"   "$H/.config/gtk-3.0/settings.ini"
lnnn "$D/configs/gtk2rc"              "$H/.gtkrc-2.0"
