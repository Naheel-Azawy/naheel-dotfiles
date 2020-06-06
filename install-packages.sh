#!/bin/sh

D="$PWD"

C='\033[1m\033[34m' # info color
E='\033[1m\033[31m' # error color
R='\033[0m'         # reset color

installed=$( (pacman -Qet && pacman -Qm) | awk '{print $1}')

err() {
    printf "${E}ERROR:${R} %s\n" "$@" >&2
}

pkg_install() {
    doit() { true; }
    #doit() { false; }
    tag="$1"
    shift
    case "$tag" in
        pacman)
            if doit; then sudo pacman --noconfirm --needed -S "$1"; fi;;

        aur)
            if doit; then
                echo "$installed" | grep -q "^$1$" &&
                    echo "$1 is already installed" && return
                yay -S --noconfirm "$1"
            fi;;

        aur_manual)
            if doit; then
                helper="$1"
                [ -f /usr/bin/"$helper" ] || (
                    cd /tmp || return 1
                    rm -rf /tmp/"$helper"*
                    curl -sO https://aur.archlinux.org/cgit/aur.git/snapshot/"$helper".tar.gz &&
                        tar -xvf "$helper".tar.gz &&
                        cd "$helper" &&
                        makepkg --noconfirm -si
                    cd /tmp || return 1)
            fi;;

        pip)
            if doit; then sudo pip3 install "$1"; fi;;

        pip2)
            if doit; then sudo pip2.7 install "$1"; fi;;

        npm)
            if doit; then sudo npm install -g "$1"; fi;;

        go)
            if doit; then go get -u "$1"; fi;;

        git)
            if doit; then
                dir=$(mktemp -d)
                git clone --depth 1 "$1" "$dir" &&
                    cd "$dir" && {
                        if [ -f autogen.sh ];  then ./autogen.sh; fi
                        if [ -f ./configure ]; then ./configure;  fi
                    } && sudo make &&
                    sudo make install &&
                    cd /tmp &&
                    sudo rm -rf "$dir" || return 1
            fi;;

        suckless)
            if doit; then
                link="$1"
                name=${link##*/}
                conf="$D/configs/$name-config.h.diff"
                dir=$(mktemp -d)
                git clone --depth 1 "$link" "$dir" &&
                    cd "$dir" &&
                    sudo make &&
                    sudo cp config.def.h config.h && {
                        [ -f "$conf" ] && sudo patch config.h "$conf"
                        sudo make install
                    } &&
                    cd /tmp &&
                    sudo rm -rf "$dir" || return 1
            fi;;

        func)
            case "$1" in
                tpm)
                    if doit; then
                        rm -rf "$HOME/.tmux"
                        mkdir -p "$HOME/.tmux/plugins/tpm"
                        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
                        tmux source "$HOME/.tmux.conf" ||:
                    fi;;

                blackarch)
                    if doit; then
                        cd /tmp || return 1
                        curl -O https://blackarch.org/strap.sh || return 1
                        test "$(sha1sum strap.sh | cut -d ' ' -f1)" = \
                             9c15f5d3d6f3f8ad63a6927ba78ed54f1a52176b || {
                            err 'Failed verifying blackarch strap script hash'
                            return 1
                        }
                        chmod +x strap.sh && sudo ./strap.sh || return 1
                    fi;;

                *)
                    err "No special function '$1'" && return 1;;
            esac;;

        *)
            err "Unknow package tag '$tag'" && return 1;;
    esac
}

main() {
    cd "$D/packages" || exit 1
    #files="base base-gui addtions themostsignificant devel electronics games"
    files="base base-gui"
    pacs=$(for f in $files; do tail -n +3 "$f.org" | sed 's/|/ /g;s/  */ /g'; done)
    total=$(echo "$pacs" | wc -l)
    i=1
    echo "$pacs" | while read -r tag pac des; do
        printf "($i/$total) ${C}INSTALLING${R} $pac ${C}FROM${R} %s\n" "$tag"
        printf "${C}PURPOSE:${R} %s\n" "$des"
        pkg_install "$tag" "$pac" || {
            err "Failed installing '$pac'"
            exit 1
        }
        i=$((i+1))
        echo "-----------------------------"
    done
}

main
