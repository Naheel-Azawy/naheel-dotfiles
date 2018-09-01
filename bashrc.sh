stty -ixon
shopt -s autocd #Allows you to cd into directory merely by typing the directory name.
HISTSIZE= HISTFILESIZE=

export GPG_TTY=$(tty)

# Some aliases
alias e="exit"
alias u="tmux && exit"
alias uu="tmux && exit"
