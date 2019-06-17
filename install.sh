#!/bin/sh

D=$(pwd)
U="$1"
[ "$U" = "" ] && U="$USER"
if [ "$U" = "root" ]; then
    H="/root"
else
    H="/home/$U"
fi

info() { printf "\e[1;34;40m%s -------- \033[0m\n" "$@"; }

info "Updating packages"
# Enables multilib. Needed for wine
sed -i 's/#\[multilib\]/[multilib]\nInclude = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf
pacman -Syu # Upgrade the system
info "Install packages"
./install-packages.sh "$U" "$D"

info "Setting up systemd services"
systemctl enable org.cups.cupsd

info "Setting up sensors"
sensors-detect --auto
modprobe eeprom

info "Setting configs"
sudo -u "$U" "$D/update-configs.sh"

info "Setting the path"
echo "#!/bin/sh
export DOTFILES_DIR=$D
export DOTFILES_SCRIPTS=\"\$DOTFILES_DIR/scripts\"
export PATH=\"\$PATH:\$DOTFILES_SCRIPTS\"
" > "$H/.dotfiles-exports"
chmod +x "$H/.dotfiles-exports"

info "Installing some good stuff"
rm -rf "$H/.good-stuff"
mkdir -p "$H/.good-stuff"

sudo -u "$U" git clone https://github.com/Naheel-Azawy/conky-config "$H/.good-stuff/conky-config"
cd "$H/.good-stuff/conky-config"
sudo -u "$U" ./install.sh "$H"
cd "$D"

sudo -u "$U" git clone https://github.com/Naheel-Azawy/Executor "$H/.good-stuff/Executor"
cd "$H/.good-stuff/Executor"
./install
cd "$D"

rm -rf "$H/.tmux"
mkdir -p "$H/.tmux/plugins/tpm"
sudo -u "$U" git clone https://github.com/tmux-plugins/tpm "$H/.tmux/plugins/tpm"
sudo -u "$U" tmux source "$H/.tmux.conf"

info "Installing Spacemacs"
rm -rf "$H/.emacs.d"
sudo -u "$U" git clone https://github.com/syl20bnr/spacemacs "$H/.emacs.d"
