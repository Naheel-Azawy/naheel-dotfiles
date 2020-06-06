#!/bin/sh

D="$PWD"

info() { printf "\e[1;34;40m%s -------- \033[0m\n" "$@"; }

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
    info "Looks like you're running as root!"
    echo '1) Create a new user'
    echo '2) Or login to existing one'
    printf 'Choice: [1/2] '
    read -r ans
    case "$ans" in
        1) mkuser;;
        2) echo 'Enter username:' && read -r user;;
        *) exit 1;;
    esac
    DEST="/home/$user/.dotfiles"
    rm -rf "$DEST" &&
        cp -r "$D" "$DEST" &&
        chown -R "$user" "$DEST" &&
        sudo -u "$user" sh -c "cd $DEST && ./install.sh"
    exit
}

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

echo 'DONE!!!'

[ "$(whoami)" = root ] && {
    echo 'Now log in to your user account'
    echo "\$ su $user"
}
