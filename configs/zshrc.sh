#!/bin/zsh

HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000
setopt autocd
unsetopt flow_control
bindkey -e

zshctr=0

SSH_ENV=$HOME/.ssh/env

# https://askubuntu.com/a/634573
ssh_agent_start() {
    ps -ef | grep "$SSH_AGENT_PID" | grep ssh-agent$ > /dev/null &&
        return 0
    ssh-agent | sed 's/^echo/#echo/' > "$SSH_ENV"
    chmod 600 "$SSH_ENV"
    . "$SSH_ENV" > /dev/null
    ssh-add
}
ssh_agent_init() {
    if [ -f "$SSH_ENV" ]; then
        . "$SSH_ENV" > /dev/null
    fi
}

exists() {
    command -v "$1" >/dev/null
}

pyenv_init() {
    PYENV_ROOT="$HOME/.pyenv"
    if [ -d "$PYENV_ROOT" ] && exists pyenv; then
        export PYENV_ROOT
        [ -d "$PYENV_ROOT/bin" ] && export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init - zsh)"

        if ! [ -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ]; then
            echo 'Remember to install virtualenv plugin'
            echo "git clone https://github.com/pyenv/pyenv-virtualenv.git $PYENV_ROOT/plugins/pyenv-virtualenv"
        fi
    fi
}

zsh_init_interactive() {
    zstyle :compinstall filename "$HOME/.zshrc"
    autoload -Uz compinit
    compinit
    setopt interactivecomments

    export GPG_TTY=$(tty)
    export TERM="xterm-256color"

    export PS1="%F{green}%1~%F{reset}> "
    precmd() {
        local s=$?
        local ps_face
        local color_cwd
        local suffix

        if [ $s != 0 ]; then
            ps_face=$'%F{red}:( %F{reset}'
        else
            ps_face=
        fi

        case "$USER" in
            root|toor)
                color_cwd='%F{red}'
                suffix='#' ;;
            *)
                color_cwd='%F{green}'
                suffix='>' ;;
        esac

        local git_branch
        git_branch=$(git branch --show-current 2>/dev/null)
        [ -n "$git_branch" ] && git_branch=" ($git_branch)"

        PS1=''
        PS1="%F{249}$PS1%T%F{reset} "
        PS1="$PS1$CONDA_PROMPT_MODIFIER"
        PS1="$PS1$ps_face"
        PS1="$PS1$color_cwd%1~"
        PS1="$PS1$git_branch"
        PS1="$PS1%F{reset}$suffix "
    }

    zsh_greeting() {
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
            echo "PWD=$PWD"
        fi
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

    ls() {
        command ls --color --group-directories-first "$@"
    }

    mkdircd() {
        mkdir -p "$1" && cd "$1"
    }

    fmz() {
        tmp=$(mktemp)
        cwd="$PWD"
        cd || return 1
        env -C "$cwd" fmz --cd "$tmp" "$@"
        res=$(tail -n 1 "$tmp")
        if [ -d "$res" ] && [ "$res" != "$cwd" ]; then
            echo cd "$res"
        fi
        cd "$res" || cd "$cwd" || return 1
        rm "$tmp"
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

    # TODO diffstr
    # TODO wdiffstr
    # TODO diffbin
    # TODO diffpdf
    # TODO wdiffpdf

    ip() {
        command ip --color=auto "$@"
    }

    plot() {
        command plot "$@" & disown
    }

    unansi() {
        sed 's/\x1b\[[0-9;]*m//g'
    }

    bool() {
        if "$@"; then echo true
        else echo false; fi
    }

    try_export()   { [ -d "$2" ] && export "$1=$2";:;         }
    try_add_path() { [ -d "$1" ] && export PATH="$PATH:$1";:; }

    test -f "$DOTFILES_DIR/configs/more-paths.sh" && \
        source "$DOTFILES_DIR/configs/more-paths.sh"
    test -f ~/.config/prayer/rc && \
        source ~/.config/prayer/rc

    # TODO source "$DOTFILES_DIR/scripts/nd-complete.fish"

    alias java='java "$SHHH_JAVA_OPTIONS"' # check profile
    alias please=sudo

    bindkey -s '^q'      'exit\n'
    bindkey    '^[[1;5C' forward-word
    bindkey    '^[[1;5D' backward-word
    bindkey    '^H'      backward-kill-word
    bindkey    ';5~'     kill-word
    bindkey    '^[[3~'   delete-char
    bindkey    '^[[1~'   beginning-of-line

    abbr_file=~/.config/zsh-abbr/user-abbreviations
    if [ ! -f "$abbr_file" ]; then
        mkdir -p "$(dirname "$abbr_file")"
        cat > "$abbr_file" <<EOF
abbr ث='exit'
abbr مس='ls'
abbr م='ls'
abbr ؤي='cd'
abbr ب='fmz'

abbr bahs='bash'
abbr e='exit'
abbr ee='exit'
abbr E='exit'
abbr q='exit'
abbr qq='exit'
abbr c='clear'
abbr l='ls'
abbr ll='ls -lh'
abbr la='ls -lha'
abbr cd..='cd ..'
abbr mkd='mkdir -p'
abbr mkdc='mkdircd'
abbr cdc='cd \$(clipboard)'
abbr g='grep'
abbr gr='grep -r'

abbr stime='date "+%s"'    # time in seconds
abbr mtime='date "+%s%3N"' # time in milliseconds
abbr ntime='date "+%s%N"'  # time in nanoseconds

abbr gita='git add -A'
abbr gitc='git commit -m'
abbr gitp='git push origin'
abbr gits='git status'
abbr gitd='git diff'
abbr gitl='git log'
abbr gito='git checkout'
abbr gitq='git add -A && git commit -m "quick update" && git push origin'
abbr gitn='git clone'

abbr ed='edit'
abbr o='open'
abbr m='tmux'
abbr f='fmz'
abbr s='please'
abbr cb='clipboard'
abbr py='python3'
abbr trn='trans'
abbr trna='trans :ar'
abbr trnp='trans -b --play'
abbr ddd='please dd status=progress bs=2048 if=... of=...'
abbr cath='highlight --replace-tabs=4 --out-format=xterm256 --force'
abbr pc='please pacman -S'
abbr pcs='pacman -Ss'
abbr pcu='please pacman -Syu'
abbr cm='cmatrix'
abbr chx='chmod +x'
abbr ch-x='chmod -x'
abbr d='docker'
abbr https='python3 -m http.server'
abbr jql='jq -C . | less -R'
abbr dsync='rsync -rtu --delete --info=del,name,stats2'
abbr cl='calc'
abbr awkp="awk '{print \$1}'"
abbr p='prayer'
abbr yt='yt-dlp --add-metadata -ic'
abbr yta='yt-dlp --add-metadata -xic --audio-format mp3'
abbr ports='netstat -tulnp'
abbr backup='rsync -avx --delete --info=progress2,del,name,stats2'
abbr t='eval "\$(tools path)"'
abbr lw='latexwrapper'
abbr ly='lyrics'
abbr mu='ndg music'
abbr scp='rsync --progress'
abbr psed='perl -pe'
abbr idf='idf.py'
abbr tf='pyenv_init && pyenv activate tf'
EOF
    fi

    zsh_init_plugins
    ssh_agent_init
    zsh_greeting
}

zsh_init_plugins() {
    plugins=()
    zsh_plugin() {
        local p=$1
        local u=$2
        local h=$3
        local d=~/.local/share/zsh-plugins
        local f="$d/$p"

        if [ ! -f "$f" ]; then
            (
                mkdir -p "$d"
                cd "$d" || return 1
                zip=$(basename "$u")
                echo "Downloading plugin $p..."
                curl -L "$u" > "$zip"
                h_real=$(sha256sum < "$zip" | cut -d ' ' -f1)

                if [ -z "$h" ]; then
                    echo "Signature of $u is $h_real, nothing is sourced"
                    rm "$zip"
                    return 2
                elif [ "$h_real" != "$h" ]; then
                    echo "Failed matching signature for $zip"
                    return 1
                fi
                unzip "$zip"
                rm -rf "$zip"
            ) || return
        fi

        source "$f" &&
            plugins+=("$f")
    }

    # make zsh fishy

    zsh_plugin \
        zsh-syntax-highlighting-0.8.0/zsh-syntax-highlighting.plugin.zsh \
        https://github.com/zsh-users/zsh-syntax-highlighting/archive/refs/tags/0.8.0.zip \
        e8c214bf96168f13eaa9d2b78fd3e58070ecf11963b3a626fe5df9dfe0cf2925

    zsh_plugin \
        zsh-autosuggestions-0.7.0/zsh-autosuggestions.plugin.zsh \
        https://github.com/zsh-users/zsh-autosuggestions/archive/refs/tags/v0.7.0.zip \
        ad68b8af2a6df6b75f7f87e652e64148fd9b9cfb95a2e53d6739b76c83dd3b99

    zsh_plugin \
        zsh-abbr-5.8.0/zsh-abbr.plugin.zsh \
        https://github.com/olets/zsh-abbr/archive/refs/tags/v5.8.0.zip \
        66c30d5a7f69e682c352e4985d0bab3e0dccb38b6a911054ec6d007a14b829fd

    zsh_plugin \
        zsh-history-substring-search-1.1.0/zsh-history-substring-search.plugin.zsh \
        https://github.com/zsh-users/zsh-history-substring-search/archive/refs/tags/v1.1.0.zip \
        a7de194803e52a9de09781ee4794308f338f93c6e3cd2750d88421f843eec134 && {
        bindkey '^[[A' history-substring-search-up
        bindkey '^[[B' history-substring-search-down
    }
}

if [[ $- == *i* ]]; then
    zsh_init_interactive
fi
