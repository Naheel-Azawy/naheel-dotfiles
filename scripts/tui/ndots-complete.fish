#!/bin/fish

set -l s '__fish_seen_subcommand_from'
set -l n 'not __fish_seen_subcommand_from'

set -l c install update link list help
complete -c ndots -n "$n $c" -f -a install   -d 'Install a (listed package), (package group), or "dots"'
complete -c ndots -n "$n $c" -f -a update    -d 'Update configs (link too)'
complete -c ndots -n "$n $c" -f -a link      -d 'Link configs'
complete -c ndots -n "$n $c" -f -a list      -d 'List package groups and packages'
complete -c ndots -n "$n $c" -f -a newscript -d 'Create a new script'
complete -c ndots -n "$n $c" -f -a gits      -d 'git status'
complete -c ndots -n "$n $c" -f -a gitd      -d 'git diff'
complete -c ndots -n "$n $c" -f -a gitp      -d 'git pull'
complete -c ndots -n "$n $c" -f -a help      -d 'Show help'

complete -c ndots -n "$s install" -a '(ndots list -d)' -r -f
complete -c ndots -n "$s list"    -a '(ndots list -d groups)' -r -f
