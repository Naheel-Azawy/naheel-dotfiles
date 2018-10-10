#!/bin/bash

# Vars

D=$(pwd)
U=$1
[ "$U" = "" ] && U=$USER
if [ "$U" = "root" ]; then
    H="/root"
else
    H="/home/$U"
fi

# Install packages

sed -i 's/#\[multilib\]/[multilib]\nInclude = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf # Enables multilib. Needed for wine
pacman -Syu # Upgrade the system
./install-packages.sh "$U" "$D"

# Systemd services

echo "Setting up services"
./setup-services.sh "$U" "$D/scripts/lockscreen"

# Backlight rules

echo "Setting the backlight rules"
echo 'ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="acpi_video0", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="acpi_video0", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"' > /etc/udev/rules.d/backlight.rules

# Sensors

sensors-detect --auto
modprobe eeprom

# Setting the path

echo "Linking!!!"
echo "#!/bin/sh
export DOTFILES_DIR=$D
export DOTFILES_SCRIPTS=\"\$DOTFILES_DIR/scripts\"
export PATH=\"\$PATH:\$DOTFILES_SCRIPTS\"
" > "$H/.dotfiles-exports"
chmod +x "$H/.dotfiles-exports"

./link.sh "$D" "$U" "$H"

# Installing some good stuff

echo "Installing some good stuff"
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

# Spacemacs

echo "Cloning Spacemacs"
rm -rf "$H/.emacs.d"
git clone https://github.com/syl20bnr/spacemacs "$H/.emacs.d"

# Changing owner
chown "$U" "$H/.good-stuff/*"
chown "$U" "$H/.emacs.d/*"
