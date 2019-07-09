#!/bin/sh
D="$1"
U="$2"
H="$3"

[ "$D" = "" ] && D="$DOTFILES_DIR"
[ "$D" = "" ] && D=$(pwd)
[ "$U" = "" ] && U="$USER"
[ "$H" = "" ] && H="$HOME"

lnnn() {
    rm -rf "$2" 2> /dev/null
    ln -s "$1" "$2"
}

mkdir -p "$H/.config/dunst"
lnnn "$D/configs/dunstrc" "$H/.config/dunst/dunstrc"

mkdir -p "$H/.config/fish"
lnnn "$D/configs/fish-config.fish" "$H/.config/fish/config.fish"

mkdir -p "$H/.config/fontconfig"
lnnn "$D/configs/fonts.conf" "$H/.config/fontconfig/fonts.conf"

mkdir -p "$H/.config/youtube-viewer"
lnnn "$D/configs/youtube-viewer.conf" "$H/.config/youtube-viewer/youtube-viewer.conf"

mkdir -p "$H/.config/zathura"
lnnn "$D/configs/zathurarc" "$H/.config/zathura/zathurarc"

mkdir -p "$H/.config/lf"
lnnn "$D/configs/lfrc.sh" "$H/.config/lf/lfrc"

mkdir -p "$H/.config/sxiv/exec/"
lnnn "$D/configs/sxiv-key-handler.sh" "$H/.config/sxiv/exec/key-handler"

lnnn "$D/configs/compton.conf"   "$H/.config/compton.conf"
lnnn "$D/configs/user-dirs.dirs" "$H/.config/user-dirs.dirs"

mkdir -p "$H/.mednafen"
lnnn "$D/configs/mednafen.cfg" "$H/.mednafen/mednafen.cfg"

lnnn "$D/configs/bashrc.sh"     "$H/.bashrc"
lnnn "$D/configs/profile"       "$H/.profile"
lnnn "$D/configs/profile"       "$H/.bashrc_profile"
lnnn "$D/configs/profile"       "$H/.xprofile"
lnnn "$D/configs/xinitrc.sh"    "$H/.xinitrc"
lnnn "$D/configs/Xresources"    "$H/.Xresources"
lnnn "$D/configs/Xmodmap"       "$H/.Xmodmap"
lnnn "$D/configs/tmux.conf"     "$H/.tmux.conf"
lnnn "$D/configs/spacemacs.el"  "$H/.spacemacs"
lnnn "$D/configs/more-paths.sh" "$H/.more-paths"

mkdir -p "$H/.config/networkmanager-dmenu"
lnnn "$D/configs/nm-dmenu.ini" "$H/.config/networkmanager-dmenu/config.ini"

mkdir -p "$H/.icons/default"
lnnn "$D/configs/gtk-icons.theme" "$H/.icons/default/index.theme"

mkdir -p "$H/.config/gtk-3.0"
lnnn "$D/configs/gtk3-settings.ini" "$H/.config/gtk-3.0/settings.ini"

lnnn "$D/configs/gtk2rc" "$H/.gtkrc-2.0"
