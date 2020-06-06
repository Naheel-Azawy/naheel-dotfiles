#!/bin/sh

D="$PWD"

mkuser() {
    echo 'Enter username:'
    read -r user
    useradd -m -g wheel "$user"
    echo 'Enter password:'
    passwd "$user"
    sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' \
        /etc/sudoers 2>/dev/null
}

[ "$(whoami)" = root ] && {
    echo "Looks like you're running as root!"
    echo '1. Create a new user? 2. Or login to existing one? [1/2] '
    read -r user
    [ "$user" != 2 ] && mkuser
    sudo -u "$user" "$0"
    exit
}

info() { printf "\e[1;34;40m%s -------- \033[0m\n" "$@"; }

info "Updating packages"
# Enables multilib. Needed for wine
sudo sed -i 's/#\[multilib\]/[multilib]\nInclude = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf
sudo pacman --noconfirm -Syu # Upgrade the system

info "Install packages"
./install-packages.sh

info "Setting up systemd services"
sudo systemctl enable org.cups.cupsd

info "Setting up sensors"
sudo sensors-detect --auto
sudo modprobe eeprom

info "Setting configs"
./update-configs.sh

info "Setting the path"
echo "#!/bin/sh
export DOTFILES_DIR=$D
export DOTFILES_SCRIPTS=\"\$DOTFILES_DIR/scripts\"
export PATH=\"\$PATH:\$DOTFILES_SCRIPTS\"
" > "$HOME/.dotfiles-exports"
chmod +x "$HOME/.dotfiles-exports"

