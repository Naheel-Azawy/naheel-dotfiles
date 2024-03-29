#!/bin/sh

# Example for $XDG_CONFIG_HOME/sxiv/exec/image-info
# Called by sxiv(1) whenever an image gets loaded.
# The output is displayed in sxiv's status bar.
# Arguments:
#   $1: path to image file
#   $2: image width
#   $3: image height
#   $4: image/video

s="  " # field separator

exec 2>/dev/null

video_duration() {
    f="$1"
    duration=$(ffprobe -v quiet -of default=noprint_wrappers=1:nokey=1 -show_entries format=duration "$f")
    h=$(echo "$duration/3600" | bc)
    m=$(echo "$duration%3600/60" | bc)
    s=$(echo "$duration%60/1" | bc)
    if [ "$h" = 0 ]; then
        printf '%02d:%02d\n' "$m" "$s"
    else
        printf '%02d:%02d:%02d\n' "$h" "$m" "$s"
    fi
}

path="$1"
filename=$(basename -- "$path")
filesize=$(du -Hh -- "$path" | cut -f 1)
geometry="${2}x${3}"
type=
[ "$4" = video ] && {
    dur=$(video_duration "$path")
    type="${s} $dur${s}(play with ctrl-space)"
    filename="⯈ $filename"
}

# caption text
txt="$path.txt"
[ -f "$txt" ] || txt="$path.org"
[ -f "$txt" ] || txt="$path.html"
[ -f "$txt" ] || txt="${path%%.*}.txt"
if [ -f "$txt" ]; then
    caption=$(cat "$txt")
    equals=$(echo "$caption" | sed -rn 's/EQUAL (.+)/\1/p')
    if [ -f "$equals" ]; then
        equals="$equals.txt"
        caption=$(cat "$equals")
    fi
    caption=$(echo "$caption" | tr '\n' ' ' | fribidi --nopad)
    caption="${s}$caption"
fi

echo "${filename}${s}${filesize}${s}${geometry}${type}${caption}"

