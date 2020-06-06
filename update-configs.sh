#!/bin/sh

mkdir -p "$HOME/.config/i3"
./configs/i3.conf.gen.sh

mkdir -p "$HOME/.config/i3blocks"
./configs/i3blocks.conf.gen.sh

./configs/onboard-gsettings.sh

./link.sh
