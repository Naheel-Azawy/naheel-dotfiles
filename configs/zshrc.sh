#!/bin/zsh

HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000
setopt autocd
unsetopt flow_control
bindkey -e

if [[ $- == *i* ]]; then
    zstyle :compinstall filename '/home/naheel/.zshrc'
    autoload -Uz compinit
    compinit

    export GPG_TTY=$(tty)
    export TERM="xterm-256color"

    export PS1="%F{040}%1~%F{015}%K{000}> "
    precmd() {
        if [ $? != 0 ]; then
            ps_face=$'\e[0;31;40m:( \e[0m'
        else
            ps_face=
        fi

        local color_cwd
        local suffix
        case "$USER" in
            root|toor)
                color_cwd=$'\e[0;31;40m'
                suffix='#' ;;
            *)
                color_cwd=$'\e[0;32;40m'
                suffix='>' ;;
        esac

        local git_branch
        git_branch=$(git branch --show-current 2>/dev/null)
        [ -n "$git_branch" ] && git_branch=" ($git_branch)"

        PS1=$'\e[0;37;40m%T\e[0m '
        PS1="$PS1$CONDA_PROMPT_MODIFIER"
        PS1="$PS1$ps_face"
        PS1="$PS1$color_cwd"
        PS1="$PS1%1~"
        PS1="$PS1$git_branch"
        PS1="$PS1"$'\e[0m'"$suffix "
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

    exists() {
        command -v "$1" >/dev/null
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
        command fmz --cd "$tmp" "$@"
        res=$(tail -n 1 "$tmp")
        if [ -d "$res" ] && [ "$res" != "$PWD" ]; then
            echo cd "$res"
            cd "$res" || return 1
        fi
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

    idf.py() {
        if [ -z $IDF_PATH]; then
            esp_idf_exports="$HOME/.local/share/esp/esp-idf/export.sh"
            if [ -f "$esp_idf_exports" ]; then
                . "$esp_idf_exports"
            else
                mkdir -p "$HOME/.local/share/esp" &&
                    cd "$HOME/.local/share/esp" &&
                    git clone --recursive https://github.com/espressif/esp-idf.git &&
                    cd esp-idf &&
                    ./install.sh esp32
            fi
        fi
        env MENUCONFIG_STYLE='aquatic list=fg:white,bg:black' idf.py "$@"
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
EOF
    fi

    # add fish-like capabilities
    # pacman -S zsh-autosuggestions zsh-completions zsh-syntax-highlighting zsh-history-substring-search
    # yay -S zsh-abbr
    d=/usr/share/zsh/plugins
    source $d/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
    source $d/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
    source $d/zsh-history-substring-search/zsh-history-substring-search.zsh
    source $d/zsh-abbr/zsh-abbr.plugin.zsh

    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down

    zsh_greeting
fi
