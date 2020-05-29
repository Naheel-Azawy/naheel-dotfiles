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

path="$1"
filename=$(basename -- "$path")
filesize=$(du -Hh -- "$path" | cut -f 1)
geometry="${2}x${3}"
type=
[ "$4" = video ] && type="${s}(video, press ctrl-space to play)"

# used to show the caption in files downloaded with "instaloader"
txt=$(echo "$path" | sed -En 's@(.+)\....@\1.txt@p')
if [ -f "$txt" ]; then
    caption=$(head -n1 "$txt" | tr '\n' ' ' | fribidi --nopad)
    caption="${s}\"$caption\""
fi

echo "${filesize}${s}${geometry}${s}${filename}${type}${caption}"

