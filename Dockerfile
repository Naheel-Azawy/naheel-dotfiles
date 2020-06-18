FROM archlinux:latest

LABEL maintainer="Naheel-Azawy"

RUN cd && rm -rf naheel-dotfiles-master && curl -sL https://github.com/Naheel-Azawy/naheel-dotfiles/archive/master.tar.gz | tar xz && mv naheel-dotfiles-master .dotfiles && cd .dotfiles && ./install.sh --quick base

CMD sudo -u main sh -c 'cd && . ~/.profile && tmux'
