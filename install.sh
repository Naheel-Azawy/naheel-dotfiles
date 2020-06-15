#!/bin/sh

CMD='cd && rm -rf naheel-dotfiles-master && curl -sL https://github.com/Naheel-Azawy/naheel-dotfiles/archive/master.tar.gz | tar xz && mv naheel-dotfiles-master .dotfiles && cd .dotfiles && ./install.sh'

if [ "$1" = '--docker' ]; then
    exec docker run --name arch-naheel -it archlinux sh -c "$CMD --quick base && sudo -u main sh -c 'cd && . ~/.profile && tmux'"
elif [ -f ./scripts/ndots ]; then
    exec ./scripts/ndots install dots "$@"
else
    echo 'Downloading dotfiles...'
    eval "$CMD"
fi
