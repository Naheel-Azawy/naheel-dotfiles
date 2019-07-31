#!/bin/bash

# Example for $XDG_CONFIG_HOME/sxiv/exec/key-handler
# Called by sxiv(1) after the external prefix key (C-x by default) is pressed.
# The next key combo is passed as its first argument. Passed via stdin are the
# images to act upon, one path per line: all marked images, if in thumbnail
# mode and at least one image has been marked, otherwise the current image.
# sxiv(1) blocks until this script terminates. It then checks which images
# have been modified and reloads them.

# The key combo argument has the following form: "[C-][M-][S-]KEY",
# where C/M/S indicate Ctrl/Meta(Alt)/Shift modifier states and KEY is the X
# keysym as listed in /usr/include/X11/keysymdef.h without the "XK_" prefix.

choice="$1"
[ "$1" = "C-x" ] && {
    choice=$(echo 'Information
Open with
Copy file name
Copy image
Set as wallpaper
Rotate 270
Rotate 90
Rotate 180
Flip horizontally
Flip vertically
Move to trash
Delete' | menu-interface -i -l 20)
}

# put files in an array
files=()
while IFS= read -r file; do
    echo "$file" | grep -q "^$VIDS_THUMBS_DIR" && # for videos
        file="$(echo """$file""" | sed -En """s@(.+).thumb.jpg@\\1@p""")"
    file=$(realpath "$file")
    files+=("$file")
done

case "$choice" in
    "Information" | "i")
        for f in "${files[@]}"; do theterm "exiftool '$f' | less" & done;;
    "Open with" | "o")
        open --ask -nw "${files[@]}" &;;
    "Copy file name" | "f")
        printf '%s\n' "${files[@]}" | xclip -in -selection clipboard;;
    "Copy image" | "M-w")
        for f in "${files[@]}"; do xclip -selection clipboard -target image/png "$f"; done;;
    "Set as wallpaper" | "w")
        setwallpaper "${files[-1]}";;
    "Rotate 270" | "C-comma")
        for f in "${files[@]}"; do convert "$f" -rotate 270 "$f"; done;;
    "Rotate 90" | "C-period")
        for f in "${files[@]}"; do convert "$f" -rotate  90 "$f"; done;;
    "Rotate 180" | "C-slash")
        for f in "${files[@]}"; do convert "$f" -rotate 180 "$f"; done;;
    "Flip horizontally")
        for f in "${files[@]}"; do convert "$f" -flop "$f"; done;;
    "Flip vertically")
        for f in "${files[@]}"; do convert "$f" -flip "$f"; done;;
    "Move to trash" | "t")
        for f in "${files[@]}"; do trash-put "$f"; done;;
    "Delete" | "d")
        for f in "${files[@]}"; do
            R=$(printf "Yes\nNo" | menu-interface -p \
                "Delete $(basename """$f""") permanently?" -i -sb red -nf red)
            [ "$R" = "Yes" ] && rm -f "$f";
        done;;
    "p") # play video (experimental)
        open "${files[@]}";;
esac
