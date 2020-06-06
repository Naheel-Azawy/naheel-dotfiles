#!/bin/sh

D="$PWD"
U="$USER"
H="$HOME"

info() { printf "\e[1;34;40m%s -------- \033[0m\n" "$@"; }

info "Updating packages"
# Enables multilib. Needed for wine
sed -i 's/#\[multilib\]/[multilib]\nInclude = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf
pacman -Syu # Upgrade the system

info "Install packages"
./install-packages.sh

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

