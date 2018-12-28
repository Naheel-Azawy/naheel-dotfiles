# Set the keyboard repeat delay and rate
xset r rate 230 50

# Update the x resources
[ -f ~/.Xresources ] && xrdb ~/.Xresources

# Start the window manager
exec i3
#exec gnome-session
