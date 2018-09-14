#!/bin/bash

U="$1"
D="$2"

C='\033[0;34m' # info color
R='\033[0m'    # reset color

installed=$((pacman -Qet && pacman -Qm) | awk '{print $1}')

function install-aur-manual { # Installs $1 manually if not installed. Used only for AUR helper here.
	  [[ -f /usr/bin/$1 ]] || (
	      echo -e "${C}INSTALLING${R} \"$1\", an AUR helper..."
	      cd /tmp
	      rm -rf /tmp/"$1"*
	      curl -sO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz &&
	          sudo -u "$U" tar -xvf "$1".tar.gz &&
	          cd "$1" &&
	          sudo -u $name makepkg --noconfirm -si
	      cd /tmp)
}

function install-pacman {
	  pacman --noconfirm --needed -S "$1"
}

function install-aur {
	  grep -q "^$1$" <<< "$installed" && echo "$1 is already installed" && return
	  sudo -u "$U" yay -S --noconfirm "$1"
}

function install-pip {
    pip3 install "$1"
}

function install-npm {
    npm install -g "$1"
}

function install-git {
	  dir=$(mktemp -d)
	  git clone --depth 1 "$1" "$dir"
	  cd "$dir" || exit
	  make
	  make install
	  cd /tmp
}

install-aur-manual yay

cd "$D/packages"
files="base.org addtions.org devel.org games.org"
pacs="$(for f in $files; do cat $f | tail -n +3 | sed 's/|/ /g' | sed 's/  */ /g'; done)"
total=$(echo "$pacs" | wc -l)
i=1
echo "$pacs" | while read -r tag pac des; do
    echo -e "($i/$total) ${C}INSTALLING${R} $pac ${C}FROM${R} $tag"
    echo -e "${C}REASON:${R} $des"
    case $tag in
        pacman) install-pacman $pac;;
        aur)    install-aur    $pac;;
        pip)    install-pip    $pac;;
        npm)    install-npm    $pac;;
        git)    install-git    $pac;;
        *) echo "ERROR: Unknow package tag '$tag'" && exit 1;;
    esac
    i=$((i+1))
    echo "-----------------------------"
done
