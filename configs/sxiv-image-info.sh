#!/bin/sh

# Example for $XDG_CONFIG_HOME/sxiv/exec/image-info
# Called by sxiv(1) whenever an image gets loaded.
# The output is displayed in sxiv's status bar.
# Arguments:
#   $1: path to image file
#   $2: image width
#   $3: image height

s="  " # field separator

exec 2>/dev/null

path="$1"
filename=$(basename -- "$path")
filesize=$(du -Hh -- "$path" | cut -f 1)
geometry="${2}x${3}"
type=

vid=$(echo "$path" | sed -En 's@(.+)\.thumb\.jpg@\1@p')
vid2=$(echo "$path" | sed -En 's@(.+)\.jpg@\1.mp4@p')
if [ -f "$vid" ]; then
    filename="$vid"
    filename=$(basename "$filename")
    type=' (video)'
elif [ -f "$vid2" ]; then
    type=' (video)'
fi

txt=$(echo "$path" | sed -En 's@(.+)\.jpg@\1.txt@p')
if [ -f "$txt" ]; then
    caption=$(head -n1 "$txt" | tr '\n' ' ' | fribidi --nopad)
    caption=" \"$caption\""
fi

echo "${filesize}${s}${geometry}${s}${filename}${type}${caption}"

