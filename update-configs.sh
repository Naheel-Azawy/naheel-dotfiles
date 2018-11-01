#!/bin/bash
D="$1"
U="$2"
H="$3"

[[ "$D" = "" ]] && D="$DOTFILES_DIR"
[[ "$D" = "" ]] && D="."
[[ "$U" = "" ]] && U="$USER"
[[ "$H" = "" ]] && H="$HOME"

mkdir -p "$H/.config/i3"
eval "$D/i3.conf.gen.sh $H"
mkdir -p "$H/.config/i3blocks"
eval "$D/i3blocks.conf.gen.sh $H"

eval "$D/link.sh" "$D" "$U" "$H"
