#!/bin/sh
## This file is used to generate i3.conf
## Makes this config file turing complete and tries to replace keysyms with keycodes
## Also used to view bindings documentation
## based on i3 config file (v4)
## Please see https://i3wm.org/docs/userguide.html for a complete reference!

outbindings() {
    # WM BINDINGS ------------------------------------------------------------

    bindoc 'Kill focused window' \
           "$mod+q" "kill"
    bindoc 'Ignore the tmux session (if is) and kill focused window' \
           "$mod+Shift+q" 'exec "theterm --tmux-ignore && i3-msg kill"'

    bindoc 'Enter fullscreen mode for the focused container' \
           "$mod+f" "fullscreen toggle"

    bindoc 'Toggle tiling / floating' \
           "$mod+t" "floating toggle"

    bindoc 'Toggle sticky window' \
           "$mod+Shift+t" "sticky toggle"

    bindoc 'Change focus between tiling / floating windows' \
           "$mod+slash" "focus mode_toggle"

    bindoc 'Toggle split' \
           "$mod+Shift+slash" "split t"

    bindoc 'Focus the parent container' \
           "$mod+a" "focus parent"

    bindoc 'Focus the child container' \
           "$mod+Shift+a" "focus child"

    doc 'Change focus' "$mod+{Left,Right,Up,Down}"
    bindsym "$mod+Left"  "focus left"
    bindsym "$mod+Down"  "focus down"
    bindsym "$mod+Up"    "focus up"
    bindsym "$mod+Right" "focus right"

    doc 'Move focused window' "$mod+Shift+{Left,Right,Up,Down}"
    bindsym "$mod+Shift+Left"  "move left"
    bindsym "$mod+Shift+Down"  "move down"
    bindsym "$mod+Shift+Up"    "move up"
    bindsym "$mod+Shift+Right" "move right"

    doc 'Switch to workspace' "$mod+{0-9}"
    doc 'Move focused container to workspace' "$mod+Control+{0-9}"
    doc 'Move focused container to workspace and go there' "$mod+Shift+{0-9}"
    for i in $(seq 1 10); do
        [ "$i" = 10 ] && b=0 || b=$i
        # switch to workspace
        bindsym "$mod+$b" "workspace $i"
        # move focused container to workspace
        bindsym "$mod+Control+$b" "move container to workspace $i"
        # move focused container to workspace and go there
        bindsym "$mod+Shift+$b" "move container to workspace $i; workspace $i"
    done

    bindoc 'Move to next workspace' \
           "$mod+Tab" "workspace next"
    bindoc 'Move to previous workspace' \
           "$mod+Shift+Tab" "workspace prev"

    bindoc 'Move workspace to next monitor' \
           "$mod+Control+p" "move workspace to output right"

    bindoc 'Reload the configuration file' \
           "$mod+Shift+c" "reload"
    bindoc 'Restart i3 inplace' \
           "$mod+Shift+r" "restart"

    doc 'Resize window' "$mod+Control+{Left,Right,Up,Down}"
    bindsym $mod+Control+Left  resize shrink width  10 px or 10 ppt
    bindsym $mod+Control+Down  resize grow   height 10 px or 10 ppt
    bindsym $mod+Control+Up    resize shrink height 10 px or 10 ppt
    bindsym $mod+Control+Right resize grow   width  10 px or 10 ppt

    doc 'Resize window (a little bit)' "$mod+Shift+Control+{Left,Right,Up,Down}"
    bindsym $mod+Shift+Control+Left  resize shrink width  1 px or 1 ppt
    bindsym $mod+Shift+Control+Down  resize grow   height 1 px or 1 ppt
    bindsym $mod+Shift+Control+Up    resize shrink height 1 px or 1 ppt
    bindsym $mod+Shift+Control+Right resize grow   width  1 px or 1 ppt

    # GENERAL BINDINGS -------------------------------------------------------

    bindoc 'Start a terminal' \
           "$mod+Return"               "exec theterm"
    bindoc 'Start a terminal with opposite split' \
           "$mod+Shift+Return"         "split t; exec theterm"
    bindoc 'Start a terminal (without tmux)' \
           "$mod+Control+Return"       "exec $TERMINAL"
    bindoc 'Start a terminal with opposite split (without tmux)' \
           "$mod+Shift+Control+Return" "split t; exec $TERMINAL"

    bindoc 'Start file manager' \
           "$mod+apostrophe"       "exec theterm lf"
    bindoc 'Start file manager with opposite split' \
           "$mod+Shift+apostrophe" "split t; exec theterm lf"

    bindoc 'Empty window' \
           "$mod+e"                "exec empty"
    bindoc 'Empty window with opposite split' \
           "$mod+Shift+e" "split t; exec empty"

    bindoc 'Start the program launcher' \
           "$mod+d" "exec dmenulauncher"

    bindoc 'Switch language' \
           "$mod+space" "exec lang-toggle"

    bindoc 'Switch language (extended)' \
           "$mod+Shift+space" "exec lang-toggle -e"

    bindoc 'Toggle on-screen keyboard' \
           "$mod+k" "exec sh -c 'pkill onboard || onboard'"

    bindoc 'Open the internet browser' \
           "$mod+b" "exec --no-startup-id $BROWSER"

    bindoc 'Open calculator' \
           "$mod+plus" "exec --no-startup-id calc-floating"

    bindoc 'Open tiny camera' \
           "$mod+minus" "exec --no-startup-id tiny-camera"

    bindoc 'Lock screen' \
           "$mod+l"       "exec --no-startup-id lockscreen"
    bindoc 'Power options' \
           "$mod+Shift+l" "exec --no-startup-id dmenupower"

    bindoc 'Mount a drive' \
           "$mod+m"       "exec --no-startup-id dmenumount"

    bindoc 'Display options' \
           "$mod+p"       "exec --no-startup-id dmenudisplay"
    bindoc 'Reset display options' \
           "$mod+Shift+p" "exec --no-startup-id dmenudisplay -d"

    bindoc 'Clipboard manager' \
           "$mod+c" "exec --no-startup-id clipmenu"

    bindoc 'Common words (copy to clipboard)' \
           "$mod+w" "exec --no-startup-id dmenuwords"

    bindoc 'Unicode characters (copy to clipboard)' \
           "$mod+u" "exec --no-startup-id dmenuunicode"

    bindoc 'Get the bibliography or PDF from the current window' \
           "$mod+r" "exec --no-startup-id getbib"

    bindoc 'Youtube stuff' \
           "$mod+y" "exec --no-startup-id dmenuyoutube"

    bindoc 'Help (based on copied term)' \
           "$mod+h" "exec --no-startup-id dmenuwhat"

    bindoc 'Network manager menu' \
           "$mod+n" "exec --no-startup-id networkmanager_dmenu"

    bindoc 'Togggle opacity of current window' \
           "$mod+o" "exec --no-startup-id toggle-opacity"

    bindoc 'Toggle notifications' \
           "$mod+i" "exec --no-startup-id notiftog"

    bindoc 'Take a screenshot' \
           "Print"               "exec --no-startup-id screenshot"
    bindoc 'Take a screenshot to clipboard' \
           "Control+Print"       "exec --no-startup-id screenshot -c"
    bindoc 'Take a screenshot of area' \
           "Shift+Print"         "exec --no-startup-id screenshot -a"
    bindoc 'Take a screenshot of area to clipboard' \
           "Shift+Control+Print" "exec --no-startup-id screenshot -a -c"
    bindoc 'Take a screenshot of current window' \
           "$mod+Print"          "exec --no-startup-id screenshot -w"
    bindoc 'Take a screenshot of current window to clipboard' \
           "$mod+Control+Print"  "exec --no-startup-id screenshot -w -c"

    bindoc '¯\_(ツ)_/¯' \
           "$mod+backslash"       "exec theterm lolcowforune"
    bindoc '¯\_(ö)_/¯' \
           "$mod+Shift+backslash" "exec theterm lolcowforune -p"

    bindoc 'Jump to quick command' \
           "$mod+j" "exec quickcmd"
    bindoc 'Edit to quick command' \
           "$mod+Control+j" "exec quickcmd -e"

    bindoc 'Show shortcuts help screen' \
           "$mod+F1" "exec theterm '\"$(realpath $0)\" -d | less'"

    bindoc 'Show the system monitor' \
           "$mod+grave" "workspace #; exec system-monitor -1"

    # PERSONAL BINDINGS ------------------------------------------------------

    # TODO: move to personal

    bindsym "$mod+Shift+v" "exec /mnt/hdd1/Private/m-launcher.sh"
    bindsym "$mod+semicolon" "exec theterm 'emacs-in $HOME/Dropbox/orgmode/TODO.org'"
    bindsym "$mod+Shift+semicolon" "exec calendar"

    # XF86 KEYS BINDINGS -----------------------------------------------------

    bindsym XF86AudioMute                    exec --no-startup-id audioctl mute
    bindsym XF86AudioLowerVolume             exec --no-startup-id audioctl down 5
    bindsym XF86AudioRaiseVolume             exec --no-startup-id audioctl up   5
    bindsym $mod+XF86AudioMute               exec --no-startup-id audioctl pause
    bindsym $mod+XF86AudioLowerVolume        exec --no-startup-id audioctl prev
    bindsym $mod+XF86AudioRaiseVolume        exec --no-startup-id audioctl next
    bindsym $mod+Shift+XF86AudioLowerVolume  exec --no-startup-id audioctl back    10
    bindsym $mod+Shift+XF86AudioRaiseVolume  exec --no-startup-id audioctl forward 10
    bindsym XF86AudioNext                    exec --no-startup-id audioctl next
    bindsym XF86AudioPlay                    exec --no-startup-id audioctl pause
    bindsym XF86AudioPrev                    exec --no-startup-id audioctl prev
    bindsym XF86AudioStop                    exec --no-startup-id audioctl stop
    bindsym XF86AudioRewind                  exec --no-startup-id audioctl back    10
    bindsym XF86AudioForward                 exec --no-startup-id audioctl forward 10
    ##bindsym XF86AudioRecord                exec
    bindsym XF86PowerOff                     exec --no-startup-id dmenupower
    ##bindsym XF86Copy                       exec
    ##bindsym XF86Open                       exec
    ##bindsym XF86Paste                      exec
    ##bindsym XF86Cut                        exec
    ##bindsym XF86MenuKB                     exec
    bindsym XF86Calculator                   exec calc-float
    ##bindsym XF86Sleep                      # This binding is typically mapped by systemd automatically.
    ##bindsym XF86WakeUp                     exec
    bindsym XF86Explorer                     exec theterm lf
    ##bindsym XF86Send                       exec
    ##bindsym XF86Xfer                       exec
    bindsym XF86WWW                          exec --no-startup-id $BROWSER
    ##bindsym XF86DOS                        exec
    bindsym XF86ScreenSaver                  exec exec --no-startup-id lockscreen
    ##bindsym XF86RotateWindows              exec
    ##bindsym XF86TaskPane                   exec
    ##bindsym XF86Favorites                  exec
    bindsym XF86MyComputer                   exec theterm lf
    ##bindsym XF86Back                       exec
    ##bindsym XF86Forward                    exec
    bindsym XF86Eject                        exec --no-startup-id dmenuumount
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
    ##bindsym XF86Mail                       exec
    ##bindsym XF86Messenger                  exec
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
    bindsym XF86Documents                    exec theterm lf "$HOME/Documents"
    ##bindsym XF86Battery                    exec
    ##bindsym XF86Bluetooth                  exec
    bindsym XF86WLAN                         exec --no-startup-id sudo -A systemctl restart NetworkManager
}

outconfigs() {
    # Defining some colors
    color_bg="#000000"
    color_bl="#285577"
    color_rd="#900000"
    color_gr="#333333"

    # Border size
    out for_window [class='"^.*"'] border pixel 2

    # Floating windows main class
    out for_window [class=".*__floatme__.*"] floating enable
    out for_window [title=".*__floatme__.*"] floating enable

    # Sticking windows main class
    out for_window [class=".*__stickme__.*"] sticky enable
    out for_window [title=".*__stickme__.*"] sticky enable

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

    # Prevent mouse focus
    out focus_follows_mouse no

    # Setting colors
    #   class                   border    backgr.   text      indicator   child_border
    out client.focused          '#4c7899' $color_bl '#ffffff' '#2e9ef4'   $color_bl
    out client.focused_inactive '#333333' '#5f676a' '#ffffff' '#484e50'   '#222222'
    out client.unfocused        '#333333' '#222222' '#888888' '#292d2e'   '#111111'
    out client.urgent           '#2f343a' '#900000' '#ffffff' '#900000'   '#900000'
    out client.placeholder      '#000000' '#0c0c0c' '#ffffff' '#000000'   '#0c0c0c'
    out client.background       '#ffffff'

    # The top bar
    block bar
    {
        out workspace_buttons no
        out status_command bar lemon
        out position top
		out tray_output none
		out mode invisible
    }
    blockend
}

outautostart() {
    # Network manager applet
    # exec --no-startup-id nm-applet

    # Starts dunst for notifications:
    exec_start --no-startup-id dunst

    # Start the clipmenu daemon
    exec_start --no-startup-id clipmenud

    # mouse setup
    exec_start --no-startup-id setup-xinput

    # Hide the mouse cursor while typing
    exec_start --no-startup-id xbanish

    # Disable touchpad while typing
    exec_start --no-startup-id syndaemon -i 0.5 -t -K -R

    # start emacs daemon
    exec_start --no-startup-id emacs-daemon

    # compositor
    exec_always --no-startup-id picom

    # wallpaper
    exec_always --no-startup-id setwallpaper

    # set language to 'us' by default, runs xmodmap as well
    exec_always --no-startup-id lang-set us

    # mount encfs private directory
    exec_always --no-startup-id mount-private
}

bindoc() {
    info="$1"
    key="$2"
    printdoc "$key" "$info"
    shift
    bindsym "$@"
}

bindocmod() {
    info="$1"
    key="$mod"
    printdoc "$key" "$info"
    shift
    out bindcode 133 --release "$@"
}

doc() {
    info="$1"
    key="$2"
    printdoc "$key" "$info"
}

exec_start()  { out exec "$@";        }
exec_always() { out exec_always "$@"; }
block()       { out "$@" '{';         }
blockend()    { out '}';              }

main() {
    DOC=''  && [ "$1" = '-d' ]          && DOC=1    && shift
    MENU='' && [ "$1" = '-m' ]          && MENU=1   && shift
    RUN=''  && [ "$1" = '-r' ]          && RUN="$2" && shift 2
    KEYS='' && [ "$1" = '--used-keys' ] && KEYS=1   && shift

    mod=Mod4

    if [ "$RUN" ]; then
        mod=Mod
        bindoc() {
            if [ "$RUN" = "$2" ]; then
                echo "$3"
                exit 0
            fi
        }
        out() { :; }
        printdoc() { :; }
        bindsym() { :; }
        outbindings
    elif [ $DOC ]; then
        mod=Mod
        out() { :; }
        printdoc() { printf '%-40s: %s\n' "$1" "$2"; }
        bindsym() { :; }
        outbindings
    elif [ $KEYS ]; then
        out() { :; }
        printdoc() { :; }
        bindsym() { echo "$1"; }
        outbindings
    elif [ $MENU ]; then
        item=$(main -d | menu-interface -i -l 20 | awk '{print $1}')
        msg=$(main -r "$item")
        dmenufixfocus -l 2>/dev/null &
        i3-msg "$msg"
    else
        OUTFILE="$HOME/.config/i3/config"
        rm -f "$OUTFILE"

        out() { echo "$@" >> "$OUTFILE"; }
        printdoc() { :; }

        CODES=$(xmodmap -pke)

        bindsym() {
            all="$@"
            # if XF86 bindsym as it is
            echo "$all" | grep -q XF86 && {
                out bindsym "$all"
                return
            }
            sym="$1"
            shift
            cmd="$@"
            start_syms=$(echo "$sym" | awk -F'+' 'NF{--NF};1' | sed 's/ /\+/g')
            [ "$start_syms" != '' ] && start_syms="$start_syms+"
            last_sym=$(echo "$sym" | awk -F'+' '{print $NF}')
            # if function key bindsym as it is
            echo "$last_sym" | grep -Eq '^F[1-9][0-2]?$' && {
                out bindsym "$all"
                return
            }
            last_code=$(echo "$CODES" | sed -En "s/keycode\s+(.+)\s+= .* ${last_sym}\s+.*/\1/p")
            if [ "$last_code" -eq "$last_code" ] 2>/dev/null; then # if a number
                out bindcode "$start_syms$last_code $cmd"
            else # otherwise bindsym as it is
                out bindsym "$all"
            fi
        }

        BINPATH=$(realpath "$0")
        out "# DO NOT EDIT!
# Generated by $BINPATH
"
        outconfigs
        outbindings
        outautostart
    fi
}

main "$@"
