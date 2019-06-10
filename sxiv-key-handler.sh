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

rotate() {
	  degree="$1"
	  tr '\n' '\0' | xargs -0 realpath | sort | uniq | while read -r file; do
		    case "$(file -b -i "$file")" in
		        image/jpeg*) jpegtran -rotate "$degree" -copy all -outfile "$file" "$file" ;;
		        *)           mogrify  -rotate "$degree" "$file" ;;
		    esac
	  done
}

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
Move to trash
Delete' | menu-interface -i -l 20)
}

case "$choice" in
    "Information" | "i")
        while read -r file; do theterm "exiftool '$file' | less" & done;;
    "Open with" | "o")
        files=()
        while read -r file; do
            files+=("$file")
        done
        eval $(echo | mimeopen --ask "${files[0]}" 2>/dev/null | \
                   sed -En 's/.+\)\s+(.+)/\1/p' | \
                   menu-interface -l 20 -p 'Open with' | \
                   sed -En 's/.+\((.+)\)/\1/p') "${files[@]}" &;;
    "Copy file name" | "f")
        xclip -in -filter | tr '\n' ' ' | xclip -in -selection clipboard;;
    "Copy image" | "M-w")
        while read -r file; do xclip -selection clipboard -target image/png "$file"; done;;
    "Set as wallpaper" | "w")
        while read -r file; do setwallpaper "$file"; done;;
    "Rotate 270" | "C-comma")
        rotate 270;;
    "Rotate 90" | "C-period")
        rotate  90;;
    "Rotate 180" | "C-slash")
        rotate 180;;
    "Move to trash" | "t")
        while read -r file; do trash-put "$file"; done;;
    "Delete" | "d")
        while read -r file; do rm -f "$file"; done;;
esac

