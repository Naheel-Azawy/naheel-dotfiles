#!/bin/bash

D=$(pwd)
U="$1"
[[ "$U" = "" ]] && U="$USER"
if [[ "$U" = "root" ]]; then
    H="/root"
else
    H="/home/$U"
fi

function info { echo -e "\e[1;34;40m$@ --------" '\033[0m'; }

info "Install packages"
sed -i 's/#\[multilib\]/[multilib]\nInclude = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf # Enables multilib. Needed for wine
pacman -Syu # Upgrade the system
./install-packages.sh "$U" "$D"

info "Setting up systemd services"
./setup-services.sh "$U" "$D/scripts/lockscreen"

info "Setting up sensors"
sensors-detect --auto
modprobe eeprom

info "Generating i3 config"
mkdir -p "$H/.config/i3"
eval "$D/i3.conf.gen.sh $H"

info "Setting the path"
echo "#!/bin/sh
export DOTFILES_DIR=$D
export DOTFILES_SCRIPTS=\"\$DOTFILES_DIR/scripts\"
export PATH=\"\$PATH:\$DOTFILES_SCRIPTS\"
" > "$H/.dotfiles-exports"
chmod +x "$H/.dotfiles-exports"

info "Linking!!!"
./link.sh "$D" "$U" "$H"

info "Installing some good stuff"
rm -rf "$H/.good-stuff"
mkdir -p "$H/.good-stuff"

git clone https://github.com/Naheel-Azawy/conky-config "$H/.good-stuff/conky-config"
cd "$H/.good-stuff/conky-config"
./install.sh "$H"
cd "$D"

git clone https://github.com/Naheel-Azawy/Executor "$H/.good-stuff/Executor"
cd "$H/.good-stuff/Executor"
./install
cd "$D"

rm -rf "$H/.tmux"
mkdir -p "$H/.tmux/plugins/tpm"
git clone https://github.com/tmux-plugins/tpm "$H/.tmux/plugins/tpm"
tmux source "$H/.tmux.conf"

info "Installing Spacemacs"
rm -rf "$H/.emacs.d"
git clone https://github.com/syl20bnr/spacemacs "$H/.emacs.d"

info "Changing owner"
chown "$U" "$H/.good-stuff/*"
chown "$U" "$H/.emacs.d/*"
chown "$U" "$H/.config" -R
