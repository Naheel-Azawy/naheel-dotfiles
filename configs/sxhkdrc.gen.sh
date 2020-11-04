#!/bin/sh

# A wrapper script over sxhkd config file.
# Used to generate the config, show the shortcuts in
# a friendly way, and few other things.
#
# Why not just bind keys from i3 config?
# - sxhkd is nicer, cleaner, and smarter
# - better to split the work
# - I used to do it in an ugly way
#   https://github.com/Naheel-Azawy/naheel-dotfiles/blob/b72670f9b75c56f765ff0a7897ef478be29b7a99/configs/i3.conf.gen.sh
# - might leave i3 someday

BINPATH=$(realpath "$0")

outbindings() {
    # WM BINDINGS ------------------------------------------------------------

    bind 'Kill focused window' \
         'super+q' 'i3-msg kill'
    bind 'Ignore the tmux session (if is) and kill focused window' \
         'super+shift+q' 'theterm --tmux-ignore && i3-msg kill'

    bind 'Enter fullscreen mode for the focused container' \
         'super+f' 'i3-msg fullscreen toggle'

    bind 'Toggle tiling / floating' \
         'super+t' 'i3-msg floating toggle'

    bind 'Toggle sticky window' \
         'super+shift+t' 'i3-msg sticky toggle'

    bind 'Change focus between tiling / floating windows' \
         'super+slash' 'i3-msg focus mode_toggle'

    bind 'Toggle split' \
         'super+shift+slash' 'i3-msg split t'

    bind 'Focus the parent container' \
         'super+a' 'i3-msg focus parent'

    bind 'Focus the child container' \
         'super+shift+a' 'i3-msg focus child'

    bind 'Change focus' \
         'super+{Left,Right,Up,Down}' 'i3-msg focus {left,right,up,down}'

    bind 'Move focused window' \
         'super+shift+{Left,Right,Up,Down}' 'i3-msg move {left,right,up,down}'

    bind 'Switch to workspace' \
         'super+{0-9}' 'i3-msg workspace {0-9}'
    bind 'Move focused container to workspace' \
         'super+ctrl+{0-9}' 'i3-msg move container to workspace {0-9}'
    bind 'Move focused container to workspace and go there' \
         'super+shift+{0-9}' 'w={0-9}; i3-msg move container to workspace $w\\; workspace $w'

    bind 'Move to next workspace' \
         'super+Tab' 'i3-msg workspace next'
    bind 'Move to previous workspace' \
         'super+shift+Tab' 'i3-msg workspace prev'

    bind 'Move workspace to next monitor' \
         'super+ctrl+p' 'i3-msg move workspace to output right'

    bind 'Reload the configuration file' \
         'super+shift+c' 'i3-msg reload'
    bind 'Restart i3 inplace' \
         'super+shift+r' 'i3-msg restart; pkill -USR1 -x sxhkd'

    bind 'Resize window' \
         'super+ctrl+{Left,Right,Up,Down}' \
         'i3-msg resize {shrink width,grow width,shrink height,grow height} 10 px or 10 ppt'

    bind 'Resize window (a little bit)' \
         'super+shift+ctrl+{Left,Right,Up,Down}' \
         'i3-msg resize {shrink width,grow width,shrink height,grow height} 1 px or 1 ppt'

    # GENERAL BINDINGS -------------------------------------------------------

    bind 'Start a terminal' \
         'super+Return'            'theterm'
    bind 'Start a terminal with opposite split' \
         'super+shift+Return'      'i3-msg split t; theterm'
    bind 'Start a terminal (without tmux)' \
         'super+ctrl+Return'       "$TERMINAL bash"
    bind 'Start a terminal with opposite split (without tmux)' \
         'super+shift+ctrl+Return' "i3-msg split t; $TERMINAL bash"

    bind 'Start file manager' \
         'super+apostrophe'       'theterm lf'
    bind 'Start file manager with opposite split' \
         'super+shift+apostrophe' 'i3-msg split t; theterm lf'

    bind 'Empty window' \
         'super+e'                       'empty'
    bind 'Empty window with opposite split' \
         'super+shift+e' 'i3-msg split t; empty'

    bind 'Start the program launcher' \
         'super+d' 'dmenulauncher'

    bind 'Switch language' \
         'super+space' 'lang tog'

    bind 'Switch language (extended)' \
         'super+shift+space' 'lang tog -e'

    bind 'Toggle on-screen keyboard' \
         'super+k' 'pkill onboard || onboard'

    bind 'Open the internet browser' \
         'super+b' "$BROWSER"

    bind 'Open calculator' \
         'super+equal' 'calc-floating'

    bind 'Open tiny camera' \
         'super+minus' 'tiny-camera'

    bind 'Lock screen' \
         'super+l'       'lockscreen'
    bind 'Power options' \
         'super+shift+l' 'dmenupower'

    bind 'Mount a drive' \
         'super+m'       'dmenumount'

    bind 'Display options' \
         'super+p'       'dmenudisplay'
    bind 'Reset display options' \
         'super+shift+p' 'dmenudisplay -d'

    bind 'Clipboard manager' \
         'super+c' 'clipmenu'

    bind 'Common words (copy to clipboard)' \
         'super+w' 'dmenuwords'

    bind 'Unicode characters (copy to clipboard)' \
         'super+u' 'dmenuunicode'

    bind 'Get the bibliography or PDF from the current window' \
         'super+r' 'getbib'

    bind 'Youtube stuff' \
         'super+y' 'dmenuyoutube'

    bind 'Help (based on copied term)' \
         'super+h' 'dmenuwhat'

    bind 'Network manager menu' \
         'super+n' 'networkmanager_dmenu'

    bind 'Togggle opacity of current window' \
         'super+o' 'toggle-opacity'

    bind 'Toggle notifications' \
         'super+i' 'notiftog'
    bind 'Notifications pop history' \
         'super+ctrl+i'  'dunstctl history-pop'
    bind 'Close all notifications' \
         'super+shift+i' 'dunstctl close-all'

    bind 'Take a screenshot' \
         'Print'            'screenshot'
    bind 'Take a screenshot to clipboard' \
         'ctrl+Print'       'screenshot -c'
    bind 'Take a screenshot of area' \
         'shift+Print'      'screenshot -a'
    bind 'Take a screenshot of area to clipboard' \
         'shift+ctrl+Print' 'screenshot -a -c'
    bind 'Take a screenshot of current window' \
         'alt+Print'      'screenshot -w'
    bind 'Take a screenshot of current window to clipboard' \
         'alt+ctrl+Print' 'screenshot -w -c'

    bind '¯\_(ツ)_/¯' \
         'super+backslash'       'lolcowforune'
    bind '¯\_(ö)_/¯' \
         'super+shift+backslash' 'lolcowforune -p'

    bind 'Jump to quick command' \
         'super+j'      'quickcmd'
    bind 'Edit to quick command' \
         'super+ctrl+j' 'quickcmd -e'

    bind 'Show shortcuts help screen' \
         'super+F1' "theterm '\"$BINPATH\" -d | less'"

    bind 'Show the system monitor' \
         'super+grave' 'i3-msg workspace \\#; system-monitor -1'

    # PERSONAL BINDINGS ------------------------------------------------------

    # TODO: move to personal

    bindhidden 'super+shift+v' '/mnt/hdd1/Private/m-launcher.sh'
    bindhidden 'super+semicolon' "emx t '$HOME/Dropbox/orgmode/TODO.org'"
    bindhidden 'super+shift+semicolon' 'calendar'

    # XF86 KEYS BINDINGS -----------------------------------------------------

    bindhidden 'XF86AudioMute'                    'audioctl mute'
    bindhidden 'XF86AudioLowerVolume'             'audioctl down 5'
    bindhidden 'XF86AudioRaiseVolume'             'audioctl up   5'
    bindhidden 'super+XF86AudioMute'              'audioctl pause'
    bindhidden 'super+XF86AudioLowerVolume'       'audioctl prev'
    bindhidden 'super+XF86AudioRaiseVolume'       'audioctl next'
    bindhidden 'super+shift+XF86AudioLowerVolume' 'audioctl back    10'
    bindhidden 'super+shift+XF86AudioRaiseVolume' 'audioctl forward 10'
    bindhidden 'XF86AudioNext'                    'audioctl next'
    bindhidden 'XF86AudioPlay'                    'audioctl pause'
    bindhidden 'XF86AudioPrev'                    'audioctl prev'
    bindhidden 'XF86AudioStop'                    'audioctl stop'
    bindhidden 'XF86AudioRewind'                  'audioctl back    10'
    bindhidden 'XF86AudioForward'                 'audioctl forward 10'
    #bindhidden XF86AudioRecord                   ''
    bindhidden 'XF86PowerOff'                     'dmenupower'
    #bindhidden 'XF86Copy'                        ''
    #bindhidden 'XF86Open'                        ''
    #bindhidden 'XF86Paste'                       ''
    #bindhidden 'XF86Cut'                         ''
    #bindhidden 'XF86MenuKB'                      ''
    bindhidden 'XF86Calculator'                   'calc-float'
    #bindhidden 'XF86Sleep'                       '' # This binding is typically mapped by systemd automatically.
    #bindhidden 'XF86WakeUp'                      ''
    bindhidden 'XF86Explorer'                     'theterm lf'
    #bindhidden 'XF86Send'                        ''
    #bindhidden 'XF86Xfer'                        ''
    bindhidden 'XF86WWW'                          "$BROWSER"
    #bindhidden 'XF86DOS'                         ''
    bindhidden 'XF86ScreenSaver'                  'lockscreen'
    #bindhidden 'XF86RotateWindows'               ''
    #bindhidden 'XF86TaskPane'                    ''
    #bindhidden 'XF86Favorites'                   ''
    bindhidden 'XF86MyComputer'                   'theterm lf'
    #bindhidden 'XF86Back'                        ''
    #bindhidden 'XF86Forward'                     ''
    bindhidden 'XF86Eject'                        'dmenuumount'
    #bindhidden 'XF86Phone'                       ''
    #bindhidden 'XF86Tools'                       ''
    bindhidden 'XF86HomePage'                     "$BROWSER https://www.duckduckgo.com"
    bindhidden 'XF86Reload'                       'restart'
    #bindhidden 'XF86ScrollUp'                    ''
    #bindhidden 'XF86ScrollDown'                  ''
    #bindhidden 'XF86New'                         ''
    #bindhidden 'XF86LaunchA'                     ''
    #bindhidden 'XF86LaunchB'                     ''
    #bindhidden 'XF86Launch2'                     ''
    #bindhidden 'XF86Launch3'                     ''
    #bindhidden 'XF86Launch4'                     ''
    #bindhidden 'XF86Launch5'                     ''
    #bindhidden 'XF86Launch6'                     ''
    #bindhidden 'XF86Launch7'                     ''
    #bindhidden 'XF86Launch8'                     ''
    #bindhidden 'XF86Launch9'                     ''
    #bindhidden 'XF86AudioMicMute'                ''
    bindhidden 'XF86TouchpadToggle'               'toggletouchpad'
    bindhidden 'XF86TouchpadOn'                   'synclient TouchpadOff=0'
    bindhidden 'XF86TouchpadOff'                  'synclient TouchpadOff=1'
    bindhidden 'XF86Suspend'                      'lockscreen'
    bindhidden 'XF86Close'                        'i3-msg kill'
    bindhidden 'XF86WebCam'                       'camtoggle'
    #bindhidden 'XF86Mail'                        ''
    #bindhidden 'XF86Messenger'                   ''
    bindhidden 'XF86Search'                       "$BROWSER https://duckduckgo.com"
    #bindhidden 'XF86Go'                          ''
    #bindhidden 'XF86Finance'                     ''
    #bindhidden 'XF86Game'                        ''
    bindhidden 'XF86Shop'                         "$BROWSER https://ebay.com"
    bindhidden 'XF86MonBrightnessDown'            'brightness -dec 15'
    bindhidden 'XF86MonBrightnessUp'              'brightness -inc 15'
    bindhidden 'shift+XF86MonBrightnessDown'      'brightness -dec 5'
    bindhidden 'shift+XF86MonBrightnessUp'        'brightness -inc 5'
    bindhidden 'XF86AudioMedia'                   'cmus-tmux-st'
    bindhidden 'XF86Display'                      'dmenudisplay'
    #bindhidden 'XF86KbdLightOnOff'               ''
    #bindhidden 'XF86KbdBrightnessDown'           ''
    #bindhidden 'XF86KbdBrightnessUp'             ''
    #bindhidden 'XF86Reply'                       ''
    #bindhidden 'XF86MailForward'                 ''
    #bindhidden 'XF86Save'                        ''
    bindhidden 'XF86Documents'                    "theterm lf '$HOME/Documents'"
    #bindhidden 'XF86Battery'                     ''
    #bindhidden 'XF86Bluetooth'                   ''
    bindhidden 'XF86WLAN'                         'sudo -A systemctl restart NetworkManager'
}

main() {
    DOC=''  && [ "$1" = '-d' ]          && DOC=1    && shift
    MENU='' && [ "$1" = '-m' ]          && MENU=1   && shift
    RUN=''  && [ "$1" = '-r' ]          && RUN="$2" && shift 2
    KEYS='' && [ "$1" = '--used-keys' ] && KEYS=1   && shift

    if [ "$RUN" ]; then
        bindhidden() { bind '' "$@"; }
        bind() {
            if [ "$RUN" = "$2" ]; then
                shift 2
                echo "$*"
                exit 0
            fi
        }
        outbindings

    elif [ "$DOC" ]; then
        bindhidden() { :; }
        bind() {
            D="$1"
            K="$2"
            shift 2
            printf '%-40s: %s\n' "$K" "$D"
        }
        outbindings

    elif [ "$KEYS" ]; then
        bindhidden() { bind '' "$@"; }
        bind() { echo "$2"; }
        outbindings

    elif [ "$MENU" ]; then
        item=$(main -d | menu-interface -i -l 20 | awk '{print $1}')
        msg=$(main -r "$item")
        dmenufixfocus -l 2>/dev/null &
        eval "$msg"

    else
        OUTFILE="$HOME/.config/sxhkd/sxhkdrc"
        bindhidden() { bind '' "$@"; }
        bind() {
            D="$1"
            K="$2"
            shift 2
            [ "$D" ] && printf '# %s\n' "$D"
            printf '%s\n\t%s\n\n' "$K" "$*"
        }
        {
            echo "# DO NOT EDIT!
# Generated by $BINPATH at $(date)
"
            outbindings
        } > "$OUTFILE"
        pkill -USR1 -x sxhkd

    fi
}

main "$@"
