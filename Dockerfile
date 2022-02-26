FROM archlinux:latest
LABEL maintainer='Naheel-Azawy'
COPY . /root/.dotfiles
RUN cd ~/.dotfiles && ./install.sh --quick base
CMD sudo -u me sh -c 'cd && . ~/.profile && tmux'
