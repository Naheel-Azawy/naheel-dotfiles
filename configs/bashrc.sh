#!/bin/bash

# Start tmux if is in an ssh session
if [ ! "$TMUX" ] && [ "$SSH_CONNECTION" ]; then
    . ~/.profile
    tmux a || tmux
fi

try_export() {   [ -d "$2" ] && export "$1=$2";:;       }
try_add_path() { [ -d "$1" ] && export PATH="$PATH:$1";:; }
test -f "$DOTFILES_DIR/configs/more-paths.sh" &&
    source "$DOTFILES_DIR/configs/more-paths.sh"

alias java='java "$SHHH_JAVA_OPTIONS"' # check profile

if [[ $- == *i* ]]; then

    command -v valsh >/dev/null && {
        source "$(valsh --source)"
    }

    stty -ixon
    shopt -s autocd
    HISTSIZE=
    HISTFILESIZE=

    export GPG_TTY=$(tty)
    export TERM="screen-256color"

    bash_greeting() {
        local user
        case "$USER" in
            root|toor)
                # show user if root
                user="$USER" ;;
            *)
                # show user only if multiple users on the machine
                if [ "$(command ls -1 /home/ | grep -cv lost+found)" -gt 1 ]; then
                    user="$USER"
                else
                    user=
                fi ;;
        esac
        if [ "$user" ]; then
            echo "New session for $USER" @ "$(hostname)"
        fi

        if [ "$SSH_CONNECTION" ]; then
            echo "SSH connection: $SSH_CONNECTION"
        fi

        # show pwd if not at home
        if [ "$PWD" != "$HOME" ]; then
            echo cd "$PWD"
        fi
    }

    export PS1='\W> '
    bash_prompt() {
        if [ $? != 0 ]; then
            ps_face='\e[0;31;40m :( \e[0m'
        else
            ps_face=
        fi

        local color_cwd
        local suffix
        case "$USER" in
            root|toor)
                color_cwd='\e[0;31;40m'
                suffix='#' ;;
            *)
                color_cwd='\e[0;32;40m'
                suffix='>' ;;
        esac

        local git_branch
        git_branch=$(git branch --show-current 2>/dev/null)
        [ -n "$git_branch" ] && git_branch=" ($git_branch)"

        PS1="$CONDA_PROMPT_MODIFIER$ps_face$color_cwd\W$git_branch\e[0m$suffix "
    }
    PROMPT_COMMAND=bash_prompt

    alias please='sudo'
    alias ls='ls --color --group-directories-first'

    alias l=ls
    alias ll='ls -lh'
    alias la='ls -lha'
    alias f=fmz
    alias e=exit
    alias q=exit
    alias d=docker
    alias t='tmux a -t 0 || tmux'

    exists() {
        command -v "$1" >/dev/null
    }

    vterm_printf(){
        # https://github.com/akermu/emacs-libvterm
        if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ] ); then
            # Tell tmux to pass the escape sequences through
            printf "\ePtmux;\e\e]%s\007\e\\" "$1"
        elif [ "${TERM%%-*}" = "screen" ]; then
            # GNU screen (screen, screen-256color, screen-256color-bce)
            printf "\eP\e]%s\007\e\\" "$1"
        else
            printf "\e]%s\e\\" "$1"
        fi
    }

    open() {
        if [ -d "$1" ]; then
            cd "$1"
        else
            command open "$@"
        fi
    }

    mkdircd() {
        mkdir -p "$1" && cd "$1"
    }

    diff() {
        if exists diff-so-fancy; then
            command diff -u "$@" | diff-so-fancy | less -RF
        elif exists colordiff; then
            command diff -u "$@" | colordiff | less -RF
        else
            command diff -u "$@" | less -RF
        fi
    }

    wdiff() {
        if exists colordiff; then
            command wdiff "$@" | colordiff | less -RF
        else
            command wdiff "$@" | less -RF
        fi
    }

    fmz() {
        tmp=$(mktemp)
        command fmz --cd "$tmp" "$@"
        res=$(tail -n 1 "$tmp")
        if [ -d "$res" ] && [ "$res" != "$PWD" ]; then
            echo cd "$res"
            cd "$res" || return 1
        fi
        rm "$tmp"
    }

    bash_greeting
fi

# BEGIN_KITTY_SHELL_INTEGRATION
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; fi
# END_KITTY_SHELL_INTEGRATION

if [ -d "$HOME/miniconda3" ]; then
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
            . "$HOME/miniconda3/etc/profile.d/conda.sh"
        else
            export PATH="$HOME/miniconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
fi
