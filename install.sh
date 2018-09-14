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

./install-packages.sh "$U" "$D"

# Systemd services

echo "Setting up services"
./setup-services.sh "$U" "$D/scripts/lockscreen"

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

# Installing emacs stuff

echo "Installing Emacs stuff"
rm -rf "$H/.emacs-stuff"
mkdir "$H/.emacs-stuff"
git clone https://github.com/hniksic/emacs-htmlize.git "$H/.emacs-stuff/emacs-htmlize"

# Changing owner
chown "$U" "$H/.good-stuff/*"
chown "$U" "$H/.emacs-stuff/*"
chown "$U" "$H/.emacs.d/*"
