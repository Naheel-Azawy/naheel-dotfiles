#!/bin/bash
D="$1"
U="$2"
H="$3"

[ "$D" = "" ] && D=.
[ "$U" = "" ] && U=$USER
[ "$H" = "" ] && H=$HOME

mkdir -p "$H/.config"
ln -s "$D" "$H/.config/ranger"

