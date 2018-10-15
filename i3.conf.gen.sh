#!/bin/bash

## This file is used to generate i3.conf
## based on i3 config file (v4)
## Please see https://i3wm.org/docs/userguide.html for a complete reference!

H="$1"
[[ "$H" == "" ]] && H="$HOME"

OUTFILE="$H/.config/i3/config"
rm -f "$OUTFILE"

function out         { echo -e "$@" >> "$OUTFILE"; }
function exec        { out exec "$@";              }
function exec_always { out exec_always "$@";       }
function bindsym     { out bindsym "$@";           }
function exec        { out exec "$@";              }
function block       { out "$@" '{';               }
function blockend    { out '}';                    }

out '# DO NOT EDIT!\n# Generated by i3.conf.gen.sh\n'

mod=Mod4
term="theterm"
netrefresh='--no-startup-id sudo -A systemctl restart NetworkManager'

# Defining some colors
color_bg="#000000"
color_bl="#285577"
color_rd="#900000"
color_gr="#333333"

# Border size
out for_window [class='"^.*"'] border pixel 2

# Hide borders if only one window is in the current workspace
out hide_edge_borders smart

# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
out font "pango:$FONT_MONO 12.5"

# Before i3 v4.8, we used to recommend this one as the default:
# font -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1
# The font above is very space-efficient, that is, it looks good, sharp and
# clear in small sizes. However, its unicode glyph coverage is limited, the old
# X core fonts rendering does not support right-to-left and this being a bitmap
# font, it doesn’t scale on retina/hidpi displays.

# Use Mouse+$mod to drag floating windows to their wanted position
out floating_modifier $mod

# Setting colors
#   class                   border    backgr.   text      indicator   child_border
out client.focused          '#4c7899' '#285577' '#ffffff' '#2e9ef4'   '#285577'
out client.focused_inactive '#333333' '#5f676a' '#ffffff' '#484e50'   '#222222'
out client.unfocused        '#333333' '#222222' '#888888' '#292d2e'   '#111111'
out client.urgent           '#2f343a' '#900000' '#ffffff' '#900000'   '#900000'
out client.placeholder      '#000000' '#0c0c0c' '#ffffff' '#000000'   '#0c0c0c'
out client.background       '#ffffff'

# The top bar
block bar
{
    block colors
    {
        #   <colorclass>       <border>   <background> <text>
        out background         $color_bg
        out statusline         '#ffffff'
        out separator          '#666666'
        out focused_workspace  $color_bl  $color_bl    '#ffffff'
        out active_workspace   $color_gr  $color_gr    '#ffffff'
        out inactive_workspace $color_bg  $color_bg    '#888888'
        out urgent_workspace   $color_rd  $color_rd    '#ffffff'
        out binding_mode       $color_rd  $color_rd    '#ffffff'
    }
    blockend
    out workspace_buttons yes
    out status_command i3blocks
    out position top
    out separator_symbol '" "'
}
blockend

# start a terminal
bindsym $mod+Return                         exec $term
bindsym $mod+Control+Return       split t\; exec $term
bindsym $mod+Shift+Return                   exec st
bindsym $mod+Shift+Control+Return split t\; exec st
#bindsym $mod+Shift+Return exec $term\; exec "bash -c 'sleep 0.2s;i3-msg floating enable;i3-msg resize set 1100px 610px;i3-msg move position 100px 200px'"

# kill focused window
bindsym $mod+q kill
# ignore the tmux session (if is) and kill focused window
bindsym $mod+Shift+q exec 'tmux-ignore && i3-msg kill'

# start dmenu (a program launcher)
bindsym $mod+d exec dmenulauncher
# There also is the (new) i3-dmenu-desktop which only displays applications
# shipping a .desktop file. It is a wrapper around dmenu, so you need that
# installed.
# bindsym $mod+d exec --no-startup-id i3-dmenu-desktop

# change focus
bindsym $mod+j focus left
bindsym $mod+k focus down
bindsym $mod+l focus up
bindsym $mod+semicolon focus right

# alternatively, you can use the cursor keys:
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+j move left
bindsym $mod+Shift+k move down
bindsym $mod+Shift+l move up
bindsym $mod+Shift+semicolon move right

# alternatively, you can use the cursor keys:
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# split in horizontal orientation
bindsym $mod+h split h

# split in vertical orientation
bindsym $mod+v split v

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
#bindsym $mod+s layout stacking
#bindsym $mod+w layout tabbed
#bindsym $mod+e layout toggle split

# toggle tiling / floating
bindsym $mod+t floating toggle

# change focus between tiling / floating windows
bindsym $mod+slash focus mode_toggle

# change language
bindsym $mod+space exec lang-toggle

# focus the parent container
bindsym $mod+a focus parent

# focus the child container
#bindsym $mod+d focus child

# Define names for default workspaces for which we configure key bindings later on.
for i in {1..10}; do
    [[ $i == 10 ]] && b=0 || b=$i
    # switch to workspace
    bindsym $mod+$b workspace $i
    # move focused container to workspace
    bindsym $mod+Control+$b move container to workspace $i
    # move focused container to workspace and go there
    bindsym $mod+Shift+$b move container to workspace $i\; workspace $i
done

# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart

# Power
bindsym $mod+x       exec --no-startup-id lockscreen
bindsym $mod+Shift+x exec --no-startup-id dmenupower

# Browser
bindsym $mod+b exec --no-startup-id $BROWSER

# resize window (you can also use the mouse for that)
bindsym $mod+Control+Left  resize shrink width  10 px or 10 ppt
bindsym $mod+Control+Down  resize grow   height 10 px or 10 ppt
bindsym $mod+Control+Up    resize shrink height 10 px or 10 ppt
bindsym $mod+Control+Right resize grow   width  10 px or 10 ppt

# resize window (a little bit)
bindsym $mod+ShiftControl+Left  resize shrink width  1 px or 1 ppt
bindsym $mod+ShiftControl+Down  resize grow   height 1 px or 1 ppt
bindsym $mod+ShiftControl+Up    resize shrink height 1 px or 1 ppt
bindsym $mod+ShiftControl+Right resize grow   width  1 px or 1 ppt

# Calculator
bindsym $mod+plus exec --no-startup-id calc-floating

# Screenshot
bindsym Print               exec --no-startup-id screenshot
bindsym Control+Print       exec --no-startup-id screenshot    -c
bindsym Shift+Print         exec --no-startup-id screenshot -a
bindsym Shift+Control+Print exec --no-startup-id screenshot -a -c
bindsym $mod+Print          exec --no-startup-id screenshot -w
bindsym $mod+Control+Print  exec --no-startup-id screenshot -w -c

# Mount / Unmount
bindsym $mod+m       exec --no-startup-id dmenumount
bindsym $mod+Shift+m exec --no-startup-id dmenuumount

# Display options
bindsym $mod+s exec --no-startup-id dmenudisplay

# Clipboard manager
bindsym $mod+c exec --no-startup-id clipmenu

# Common words
bindsym $mod+w exec --no-startup-id dmenuwords

# Unicodes
bindsym $mod+u exec --no-startup-id dmenuunicode

# Togggle opacity
bindsym $mod+o exec --no-startup-id toggle-opacity

# Get the bibliography from the current window (PDF view of browser)
bindsym $mod+r exec --no-startup-id getbib

# Network manager dmenu
bindsym $mod+n exec --no-startup-id networkmanager_dmenu

# #---Extra XF86 Keys---# #
# These are the extra media keys that some keyboards have.
bindsym XF86AudioMute                    exec --no-startup-id lmc mute
bindsym XF86AudioLowerVolume             exec --no-startup-id lmc down 5
bindsym XF86AudioRaiseVolume             exec --no-startup-id lmc up 5
bindsym $mod+XF86AudioMute               exec --no-startup-id lmc pause
bindsym $mod+XF86AudioLowerVolume        exec --no-startup-id lmc prev
bindsym $mod+XF86AudioRaiseVolume        exec --no-startup-id lmc next
bindsym XF86PowerOff                     exec --no-startup-id dmenupower
##bindsym XF86Copy                       exec
##bindsym XF86Open                       exec
##bindsym XF86Paste                      exec
##bindsym XF86Cut                        exec
##bindsym XF86MenuKB                     exec
bindsym XF86Calculator                   exec calc-float
##bindsym XF86Sleep                      # This binding is typically mapped by systemd automatically.
##bindsym XF86WakeUp                     exec
bindsym XF86Explorer                     exec $term ranger
##bindsym XF86Send                       exec
##bindsym XF86Xfer                       exec
bindsym XF86WWW                          exec --no-startup-id $BROWSER
##bindsym XF86DOS                        exec
bindsym XF86ScreenSaver                  exec exec --no-startup-id lockscreen
##bindsym XF86RotateWindows              exec
##bindsym XF86TaskPane                   exec
##bindsym XF86Favorites                  exec
bindsym XF86MyComputer                   exec $term ranger
##bindsym XF86Back                       exec
##bindsym XF86Forward                    exec
bindsym XF86Eject                        exec --no-startup-id dmenuumount
bindsym XF86AudioNext                    exec --no-startup-id lmc next
bindsym XF86AudioPlay                    exec --no-startup-id lmc pause
bindsym XF86AudioPrev                    exec --no-startup-id lmc prev
bindsym XF86AudioStop                    exec --no-startup-id lmc stop
##bindsym XF86AudioRecord                exec
bindsym XF86AudioRewind                  exec --no-startup-id lmc back 10
bindsym XF86AudioForward                 exec --no-startup-id lmc forward 10
##bindsym XF86Phone                      exec
##bindsym XF86Tools                      exec
bindsym XF86HomePage                     exec $BROWSER https://www.duckduckgo.com
bindsym XF86Reload                       restart
##bindsym XF86ScrollUp                   exec
##bindsym XF86ScrollDown                 exec
##bindsym XF86New                        exec
##bindsym XF86LaunchA                    exec
##bindsym XF86LaunchB                    exec
##bindsym XF86Launch2                    exec
##bindsym XF86Launch3                    exec
##bindsym XF86Launch4                    exec
##bindsym XF86Launch5                    exec
##bindsym XF86Launch6                    exec
##bindsym XF86Launch7                    exec
##bindsym XF86Launch8                    exec
##bindsym XF86Launch9                    exec
#bindsym XF86AudioMicMute                exec $micmute
bindsym XF86TouchpadToggle               exec --no-startup-id toggletouchpad
bindsym XF86TouchpadOn                   exec --no-startup-id synclient TouchpadOff=0
bindsym XF86TouchpadOff                  exec --no-startup-id synclient TouchpadOff=1
bindsym XF86Suspend                      exec --no-startup-id lockscreen
bindsym XF86Close                        kill
bindsym XF86WebCam                       exec --no-startup-id camtoggle
bindsym XF86Mail                         exec $term neomutt # TODO
bindsym XF86Messenger                    exec $term weechat # TODO
bindsym XF86Search                       exec $BROWSER https://duckduckgo.com
##bindsym XF86Go                         exec
##bindsym XF86Finance                    exec
##bindsym XF86Game                       exec
bindsym XF86Shop                         exec $BROWSER https://ebay.com
bindsym XF86MonBrightnessDown            exec --no-startup-id brightness -dec 15
bindsym XF86MonBrightnessUp              exec --no-startup-id brightness -inc 15
bindsym Shift+XF86MonBrightnessDown      exec --no-startup-id brightness -dec 5
bindsym Shift+XF86MonBrightnessUp        exec --no-startup-id brightness -inc 5
bindsym XF86AudioMedia                   exec --no-startup-id cmus-tmux-st
bindsym XF86Display                      exec --no-startup-id dmenudisplay
##bindsym XF86KbdLightOnOff              exec
##bindsym XF86KbdBrightnessDown          exec --no-startup-id python3 $DOTFILES_SCRIPTS/kb-lights.py -
##bindsym XF86KbdBrightnessUp            exec --no-startup-id python3 $DOTFILES_SCRIPTS/kb-lights.py +
##bindsym XF86Reply                      exec
##bindsym XF86MailForward                exec
##bindsym XF86Save                       exec
bindsym XF86Documents                    exec $term ranger "$H/Documents"
##bindsym XF86Battery                    exec
##bindsym XF86Bluetooth                  exec
bindsym XF86WLAN                         exec $netrefresh

# Network manager applet
exec --no-startup-id nm-applet

# Starts dunst for notifications:
exec --no-startup-id dunst

# Start the clipmenu daemon
exec --no-startup-id clipmenud

# conky
exec --no-startup-id conky -c "$H/.conky/naheel/bin.rc"
exec --no-startup-id conky -c "$H/.conky/naheel/main.rc"

# compton / gives conky transparency
exec --no-startup-id compton

# mouse setup
exec --no-startup-id setup-xinput

# Hide the mouse cursor while typing
exec --no-startup-id xbanish

# wallpaper
exec_always --no-startup-id feh --bg-fill "$H/.config/wall.png"
