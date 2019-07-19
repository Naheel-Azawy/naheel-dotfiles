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

VIDS_THUMBS_DIR="$HOME/.catch/vidthmbs/"

rotate() {
	  degree="$1"
    file="$2"
		case "$(file -b -i "$file")" in
		    image/jpeg*) jpegtran -rotate "$degree" -copy all -outfile "$file" "$file" ;;
		    *)           mogrify  -rotate "$degree" "$file" ;;
		esac
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

# put files in an array
files=()
while IFS= read -r file; do
    echo "$file" | grep -q "^$VIDS_THUMBS_DIR" && # for videos
        file="$(echo """$file""" | sed -En """s@$VIDS_THUMBS_DIR(.+).jpg@/\\1@p""")"
    files+=("$file")
done

case "$choice" in
    "Information" | "i")
        for file in "${files[@]}"; do theterm "exiftool '$file' | less" & done;;
    "Open with" | "o")
        open --ask -nw "${files[@]}" &;;
    "Copy file name" | "f")
        printf '%s\n' "${files[@]}" | xclip -in -selection clipboard;;
    "Copy image" | "M-w")
        for file in "${files[@]}"; do xclip -selection clipboard -target image/png "$file"; done;;
    "Set as wallpaper" | "w")
        for file in "${files[@]}"; do setwallpaper "$file"; done;;
    "Rotate 270" | "C-comma")
        for file in "${files[@]}"; do rotate 270 "$file"; done;;
    "Rotate 90" | "C-period")
        for file in "${files[@]}"; do rotate 90 "$file"; done;;
    "Rotate 180" | "C-slash")
        for file in "${files[@]}"; do rotate 180 "$file"; done;;
    "Move to trash" | "t")
        for file in "${files[@]}"; do trash-put "$file"; done;;
    "Delete" | "d")
        for file in "${files[@]}"; do rm -f "$file"; done;;
    "p") # play video (experimental)
        open "${files[@]}";;
esac
