stty -ixon
shopt -s autocd #Allows you to cd into directory merely by typing the directory name.
HISTSIZE= HISTFILESIZE=

export GPG_TTY=$(tty)

alias e="exit"
alias ee="exit"
alias ث="exit"
alias u="tmux && exit"
alias uu="tmux && exit"
alias ع="lang-toggle && tmux && exit"
