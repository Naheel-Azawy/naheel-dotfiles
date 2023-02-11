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

# TODO: replace lf commands with fmz ones, CUA keys, cleanups

LIST='Information
Open with
Copy
Move
Move to trash
Delete
Copy file name
Copy image
Rotate auto
Rotate 270
Rotate 90
Rotate 180
Flip horizontally
Flip vertically
Set as wallpaper
Set as temporary wallpaper
Drag and drop'

# put files in an array
files=()
while IFS= read -r file; do
    file=$(realpath "$file")
    files+=("$file")
done

choice="$1"
[ "$1" = "C-x" ] && {
    choice=$(echo "$LIST" | gmenu -l)
}

captiontxt() {
    path="$1"
    txt="$path.txt"
    [ -f "$txt" ] || txt="$path.org"
    [ -f "$txt" ] || txt="$path.html"
    [ -f "$txt" ] || txt="${path%%.*}.txt"
    [ -f "$txt" ] || return 1
    echo "$txt"
}

case "$choice" in
    "Information" | "i")
        for f in "${files[@]}"; do
            txt=$(captiontxt "$f")
            if [ -f "$txt" ]; then
                theterm bash -c "(cat '$txt' && echo && exiftool '$f') | less" &
            else
                theterm "exiftool '$f' | less" &
            fi
        done;;

    "Edit caption" | "c")
        f="${files[-1]}"
        txt=$(captiontxt "$f")
        [ -f "$txt" ] || txt="$f.txt"
        edit t "$txt" & ;;

    "Open with" | "o")
        app=$(echo | mimeopen --ask "${files[0]}" 2>/dev/null |
                  sed -En 's/\s*(.+\)\s+.+)/\1/p'             |
                  gmenu -l                                    |
                  sed -En 's/(.+)\).+/\1/p')
        echo "$app" | mimeopen --ask "${files[0]}" & ;;

    "Copy file name" | "f")
        printf '%s\n' "${files[@]}" | xclip -in -selection clipboard;;
    "Copy image")
        xclip -selection clipboard -target image/png "${files[-1]}";;
    "Copy" | "M-w")
        S=$(printf 'save\ncopy\n'; printf '%s\n' "${files[@]}")
        lf -remote "$S";;
    "Move" | "C-w")
        S=$(printf 'save\nmove\n'; printf '%s\n' "${files[@]}")
        lf -remote "$S";;

    "Set as wallpaper" | "w")
        ndg wallpaper "${files[-1]}";;
    "Set as temporary wallpaper")
        feh --bg-fill "${files[-1]}";;

    "Duplicate" | "2")
        sxiv "${files[@]}" &;;

    "Rotate auto")
        for f in "${files[@]}"; do convert "$f" -auto-orient "$f"; done;;
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

    "Delete")
        if [ "${#files[@]}" = 1 ]; then
            P=$(basename "$f")
        else
            P="${#files[@]} files"
        fi
        R=$(printf "Trash\nDelete permanently\nCancel" |
                gmenu -i 0 -c 3 -sb red -sf black -p "Delete $P?" \
                      --dims 550x110 --nosearch --maxlbl 100)
        case "$R" in
            Trash)   for f in "${files[@]}"; do gio trash "$f" || trash-put "$f"; done;;
            Delete*) for f in "${files[@]}"; do rm -f "$f";                       done;;
        esac;;

    "Play video" | "p")
        open "${files[@]}";;

    "Drag and drop" | "d")
        if exists dragon; then
            dragoncmd=dragon
        elif exists dragon-drop; then
            dragoncmd=dragon-drop
        else
            return 1
        fi
        $dragoncmd -a -x "${files[@]}";;

esac
