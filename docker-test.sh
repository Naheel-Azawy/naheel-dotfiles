#!/bin/sh
name=arch-naheel

echo '>>> BUILDING IMAGE'
docker run --name "$name" -it archlinux sh -c 'cd && rm -rf naheel-dotfiles-master && curl -sL https://github.com/Naheel-Azawy/naheel-dotfiles/archive/master.tar.gz | tar xz && cd naheel-dotfiles-master && ./install.sh --quick base && rm -rf naheel-dotfiles-master'

echo '>>> STARTING IMAGE'
docker start "$name"
docker exec -it "$name" sudo -u main sh -c 'cd && . ~/.profile && tmux'
