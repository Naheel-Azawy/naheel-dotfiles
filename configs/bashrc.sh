#!/bin/bash
stty -ixon
# Allows you to cd into directory merely by typing the directory name.
shopt -s autocd
HISTSIZE=
HISTFILESIZE=

export GPG_TTY=$(tty)

alias e='exit'
alias l='ls'
alias ll='ls -lh'
alias la='ls -lha'
alias f='lf'
alias x='emacs-in'
