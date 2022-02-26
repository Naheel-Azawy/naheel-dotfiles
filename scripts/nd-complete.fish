#!/bin/fish

# TODO: auto-generate

set -l s '__fish_seen_subcommand_from'
set -l n 'not __fish_seen_subcommand_from'

set -l c install update link list help

complete -c nd -n "$n $c" -f -a install   -d 'Install a (listed package), (package group), or "dots"'
complete -c nd -n "$n $c" -f -a update    -d 'Update configs (link too)'
complete -c nd -n "$n $c" -f -a link      -d 'Link configs'
complete -c nd -n "$n $c" -f -a list      -d 'List package groups and packages'
complete -c nd -n "$n $c" -f -a newscript -d 'Create a new script'
complete -c nd -n "$n $c" -f -a gits      -d 'git status'
complete -c nd -n "$n $c" -f -a gitd      -d 'git diff'
complete -c nd -n "$n $c" -f -a gitp      -d 'git pull'
complete -c nd -n "$n $c" -f -a help      -d 'Show help'

complete -c nd -n "$s install" -a '(nd list -d)' -r -f
complete -c nd -n "$s list"    -a '(nd list -d groups)' -r -f

set -l c audio brightness browser floating_calc calendar display lang lockscreen music notiftog reader input wallpaper taskmanager touchpadtog systraytog wm empty

complete -c ndg -n "$n $c" -f -a browser       -d 'Launch web browser'
complete -c ndg -n "$n $c" -f -a floating_calc -d 'Launch a floating calculator'
complete -c ndg -n "$n $c" -f -a calendar      -d 'Launch calendar'
complete -c ndg -n "$n $c" -f -a display       -d 'Launch display menu'
complete -c ndg -n "$n $c" -f -a music         -d 'Launch music player'
complete -c ndg -n "$n $c" -f -a reader        -d 'Launch documents reader'
complete -c ndg -n "$n $c" -f -a taskmanager   -d 'Launch task manager'
complete -c ndg -n "$n $c" -f -a empty         -d 'Launch an empty window'
complete -c ndg -n "$n $c" -f -a audio         -d 'Control audio and music player'
complete -c ndg -n "$n $c" -f -a brightness    -d 'Control brightness'
complete -c ndg -n "$n $c" -f -a lang          -d 'Control Input language'
complete -c ndg -n "$n $c" -f -a wm            -d 'Control window manager'
complete -c ndg -n "$n $c" -f -a input         -d 'Manage input devices'
complete -c ndg -n "$n $c" -f -a wallpaper     -d 'Manage wallpaper'
complete -c ndg -n "$n $c" -f -a notiftog      -d 'Toggle notifications'
complete -c ndg -n "$n $c" -f -a touchpadtog   -d 'Toggle touchpad'
complete -c ndg -n "$n $c" -f -a systraytog    -d 'Toggle system tray'
complete -c ndg -n "$n $c" -f -a lockscreen    -d 'Lock the screen'
