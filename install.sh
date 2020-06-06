#!/bin/sh

D="$PWD"

# used probably for docker
# makes a 'main' user and keep it passwordless
QUICK=
[ "$1" = '--quick' ] && {
    QUICK="$1"
    shift
}

PACS="$*"

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
    if [ ! "$QUICK" ]; then
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
    else
        user=main
        [ -d /home/main ] ||
            useradd -m -g wheel "$user" &&
            passwd -d "$user"
    fi

    DEST="/home/$user/.dotfiles"
    rm -rf "$DEST" &&
        cp -r "$D" "$DEST" &&
        chown -R "$user" "$DEST" && {
            sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
            sudo -u "$user" sh -c "cd $DEST && ./install.sh $QUICK $PACS"
        }

    echo 'Now log in to your user account'
    echo "\$ su $user"
    exit
}

# allow no password sudo
sudo sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

# add some commands to no password sudo if needed
nopass='%wheel ALL=(ALL) NOPASSWD: /usr/bin/updatedb,/usr/bin/shutdown,/usr/bin/reboot,/usr/bin/systemctl suspend,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/systemctl restart NetworkManager,/usr/bin/rc-service NetworkManager restart,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/yay,/usr/bin/chmod a+rw /sys/class/backlight/intel_backlight/brightness'
sudo grep -q "$nopass" /etc/sudoers || echo "$nopass" | sudo tee -a /etc/sudoers

info "Updating packages"
# Enables multilib. Needed for wine
sudo sed -i 's/#\[multilib\]/[multilib]\nInclude = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf
sudo pacman --noconfirm -Syu # Upgrade the system

info "Install packages"
./install-packages.sh "$PACS"

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

# disallow no password sudo
[ "$QUICK" ] ||
    sudo sed -i 's/%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

echo 'DONE!!!'
