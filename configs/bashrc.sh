#!/bin/bash
stty -ixon
# Allows you to cd into directory merely by typing the directory name.
shopt -s autocd
HISTSIZE=
HISTFILESIZE=

export GPG_TTY=$(tty)

export PS1='\W> '

alias e='exit'
alias l='ls'
alias ll='ls -lh'
alias la='ls -lha'
alias f='lf'
alias ed='edit'
alias t='theterm --tmux'
alias java='java $SHHH_JAVA_OPTIONS'

try_export() {   [ -d "$2" ] && export "$1=$2";:;       }
try_add_path() { [ -d "$1" ] && export PATH="$PATH:$1";:; }
test -f "$DOTFILES_DIR/configs/more-paths.sh" &&
    source "$DOTFILES_DIR/configs/more-paths.sh"
