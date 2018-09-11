#!/bin/bash

gitmakeinstall() {
	  dir=$(mktemp -d)
	  dialog --title "LARBS Installation" --infobox "Installing \`$(basename $1)\` ($n of $total) via \`git\` and \`make\`. $(basename $1) $2." 5 70
	  git clone --depth 1 "$1" "$dir" &>/dev/null
	  cd "$dir" || exit
	  make &>/dev/null
	  make install &>/dev/null
	  cd /tmp
}

maininstall() { # Installs all needed programs from main repo.
	  dialog --title "LARBS Installation" --infobox "Installing \`$1\` ($n of $total). $1 $2." 5 70
	  pacman --noconfirm --needed -S "$1" &>/dev/null
}

aurinstall() {
	  dialog --title "LARBS Installation" --infobox "Installing \`$1\` ($n of $total) from the AUR. $1 $2." 5 70
	  grep "^$1$" <<< "$aurinstalled" && return
	  sudo -u $name $aurhelper -S --noconfirm "$1" &>/dev/null
}

pipinstall() {
    sudo pip3 install "$1"
}

npminstall() {
    sudo npm install -g "$1"
}

progsfile='./programs.org'
total=$(wc -l < /tmp/progs.csv)
aurinstalled=$(pacman -Qm | awk '{print $1}')
while IFS=, read -r tag program comment; do
	  n=$((n+1))
	  case "$tag" in
	      "") maininstall "$program" "$comment" ;;
	      "aur") aurinstall "$program" "$comment" ;;
	      "git") gitmakeinstall "$program" "$comment" ;;
	      "pip") pipinstall "$program" "$comment" ;;
	      "npm") npminstall "$program" "$comment" ;;
	  esac
done < /tmp/progs.csv
