# Set the keyboard repeat delay and rate
xset r rate 230 50

# Update the x resources
xrdb ~/.Xresources

# Remap Menu button to another super key
xmodmap -e "keycode 135 = Super_R"


# Start the window manager
exec i3
#exec gnome-session
