def get_bindings(wmcmd=lambda c: f"wmctl {c}"):
    return [
    # WM BINDINGS ------------------------------------------------------------

    ('Close focused program',
     'super+q', "wmctl nice-kill"),

    ('Close focused window keeping tmux sessions',
     'super+shift+q', wmcmd("window_close")),

    ('Ignore the tmux session (if is) and kill focused window',
     'super+control+q', "theterm --tmux-ignore && " + wmcmd("window_close")),

    ('Enter fullscreen mode for the focused container',
     'super+f', wmcmd("fullscreen")),

    ('Toggle tiling / floating',
     'super+t', wmcmd("float")),

    ('Toggle sticky window',
     'super+shift+t', wmcmd("stick")),

    ('Toggle split',
     'super+shift+slash', wmcmd("split")),

    ('Change focus between tiling / floating windows',
     'super+slash', wmcmd("float_focus")),

    ('Focus the parent container',
     'super+a', wmcmd("container_focus_parent")),

    ('Focus the child container',
     'super+shift+a', wmcmd("container_focus_child")),

    ('Change focus',
     'super+{Left,Right,Up,Down}', wmcmd("window_focus")),

    ('Move focused window',
     'super+shift+{Left,Right,Up,Down}', wmcmd("window_move")),

    ('Resize window',
     'super+ctrl+{Left,Right,Up,Down}', wmcmd("window_resize")),

    ('Resize window (a little bit)',
     'super+shift+ctrl+{Left,Right,Up,Down}', wmcmd("window_resize_tiny")),

    ('Switch to workspace',
     'super+{1-9,0}', wmcmd("workspace_num")),

    ('Move focused container to workspace',
     'super+ctrl+{1-9,0}', wmcmd("workspace_move")),

    ('Move focused container to workspace and go there',
     'super+shift+{1-9,0}', wmcmd("workspace_move_go")),

    ('Move to next workspace',
     'super+Tab', wmcmd("workspace_next")),

    ('Move to previous workspace',
     'super+shift+Tab', wmcmd("workspace_prev")),

    ('Move workspace to next monitor',
     'super+ctrl+p', wmcmd("workspace_monitor_next")),

    ('Restart window manager',
     'super+shift+r', wmcmd("restart")),

    # GENERAL BINDINGS -------------------------------------------------------

    ('Start a terminal',
     'super+Return',            'theterm'),
    ('Start a terminal with opposite split',
     'super+shift+Return',      wmcmd("split") + "; theterm"),
    ('Start a terminal (without tmux)',
     'super+ctrl+Return',       "$TERMINAL bash"),
    ('Start a terminal with opposite split (without tmux)',
     'super+shift+ctrl+Return', wmcmd("split") + "; $TERMINAL bash"),

    ('Start file manager',
     'super+apostrophe',       'theterm lf'),
    ('Start file manager with opposite split',
     'super+shift+apostrophe', wmcmd("split") + "; theterm lf"),

    ('Empty window',
     'super+e', 'empty'),
    ('Empty window with opposite split',
     'super+shift+e', wmcmd("split") + "; empty"),

    ('Start the program launcher',
     'super+d', 'launcher'),

    ('Switch language',
     'super+space', 'lang tog'),

    ('Switch language (extended)',
     'super+shift+space', 'lang tog -e'),

    ('Toggle on-screen keyboard',
     'super+k', 'pkill onboard || onboard'),

    ('Open the internet browser',
     'super+b', "browser"),

    ('Open calculator',
     'super+equal', 'calc-floating'),

    ('Open tiny camera',
     'super+minus', 'tiny-camera'),

    ('Lock screen',
     'super+l',       'lockscreen'),
    ('Power options',
     'super+x',       'power'),

    ('Mount a drive',
     'super+m',       'dmenumount'),

    ('Display options',
     'super+p',       'dmenudisplay'),
    ('Reset display options',
     'super+shift+p', 'dmenudisplay -d'),

    ('Clipboard manager',
     'super+c', 'clipmenu'),

    ('Common words (copy to clipboard)',
     'super+w', 'dmenuwords'),

    ('Unicode characters (copy to clipboard)',
     'super+u', 'dmenuunicode'),

    ('Get the bibliography or PDF from the current window',
     'super+r', 'getbib'),

    ('Youtube stuff',
     'super+y', 'dmenuyoutube'),

    ('Help (based on copied term)',
     'super+h', 'dmenuwhat'),

    ('Network manager menu',
     'super+n', 'networkmanager_dmenu'),

    ('Togggle opacity of current window',
     'super+o', 'toggle-opacity'),

    ('Toggle notifications',
     'super+i', 'notiftog'),
    ('Notifications pop history',
     'super+ctrl+i',  'dunstctl history-pop'),
    ('Close all notifications',
     'super+shift+i', 'dunstctl close-all'),

    ('Take a screenshot',
     'Print',            'screenshot'),
    ('Take a screenshot to clipboard',
     'ctrl+Print',       'screenshot -c'),
    ('Take a screenshot of area',
     'shift+Print',      'screenshot -a'),
    ('Take a screenshot of area to clipboard',
     'shift+ctrl+Print', 'screenshot -a -c'),
    ('Take a screenshot of current window',
     'alt+Print',      'screenshot -w'),
    ('Take a screenshot of current window to clipboard',
     'alt+ctrl+Print', 'screenshot -w -c'),

    ('¯\_(ツ)_/¯',
     'super+backslash',       'lolcowforune'),
    ('¯\_(ö)_/¯',
     'super+shift+backslash', 'lolcowforune -p'),

    ('Jump to quick command',
     'super+j',      'quickcmd'),
    ('Edit to quick command',
     'super+ctrl+j', 'quickcmd -e'),

    ('Show shortcuts help screen',
     'super+F1', "theterm 'keybindingsgen.py -d | less'"),

    ('Show the system monitor',
     'super+grave', wmcmd("workspace") + " \\#; system-monitor -1"),

    # XF86 KEYS BINDINGS -----------------------------------------------------

    ('XF86AudioMute',                    'audioctl mute'),
    ('XF86AudioLowerVolume',             'audioctl down 5'),
    ('XF86AudioRaiseVolume',             'audioctl up   5'),
    ('super+XF86AudioMute',              'audioctl pause'),
    ('super+XF86AudioLowerVolume',       'audioctl prev'),
    ('super+XF86AudioRaiseVolume',       'audioctl next'),
    ('super+shift+XF86AudioLowerVolume', 'audioctl back    10'),
    ('super+shift+XF86AudioRaiseVolume', 'audioctl forward 10'),
    ('XF86AudioNext',                    'audioctl next'),
    ('XF86AudioPlay',                    'audioctl pause'),
    ('XF86AudioPrev',                    'audioctl prev'),
    ('XF86AudioStop',                    'audioctl stop'),
    ('XF86AudioRewind',                  'audioctl back    10'),
    ('XF86AudioForward',                 'audioctl forward 10'),
    #(XF86AudioRecord ,                  ''),
    ('XF86PowerOff',                     'power'),
    #('XF86Copy',                        ''),
    #('XF86Open',                        ''),
    #('XF86Paste',                       ''),
    #('XF86Cut',                         ''),
    #('XF86MenuKB',                      ''),
    ('XF86Calculator',                   'calc-float'),
    #('XF86Sleep',                       '' # This binding is typically mapped by systemd automatically.),
    #('XF86WakeUp',                      ''),
    ('XF86Explorer',                     'theterm lf'),
    #('XF86Send',                        ''),
    #('XF86Xfer',                        ''),
    ('XF86WWW',                          "browser"),
    #('XF86DOS',                         ''),
    ('XF86ScreenSaver',                  'lockscreen'),
    #('XF86RotateWindows',               ''),
    #('XF86TaskPane',                    ''),
    #('XF86Favorites',                   ''),
    ('XF86MyComputer',                   'theterm lf'),
    #('XF86Back',                        ''),
    #('XF86Forward',                     ''),
    ('XF86Eject',                        'dmenuumount'),
    #('XF86Phone',                       ''),
    #('XF86Tools',                       ''),
    ('XF86HomePage',                     "browser https://www.duckduckgo.com"),
    ('XF86Reload',                       'restart'),
    #('XF86ScrollUp',                    ''),
    #('XF86ScrollDown',                  ''),
    #('XF86New',                         ''),
    #('XF86LaunchA',                     ''),
    #('XF86LaunchB',                     ''),
    #('XF86Launch2',                     ''),
    #('XF86Launch3',                     ''),
    #('XF86Launch4',                     ''),
    #('XF86Launch5',                     ''),
    #('XF86Launch6',                     ''),
    #('XF86Launch7',                     ''),
    #('XF86Launch8',                     ''),
    #('XF86Launch9',                     ''),
    #('XF86AudioMicMute',                ''),
    ('XF86TouchpadToggle',               'toggletouchpad'),
    ('XF86TouchpadOn',                   'synclient TouchpadOff=0'),
    ('XF86TouchpadOff',                  'synclient TouchpadOff=1'),
    ('XF86Suspend',                      'lockscreen'),
    ('XF86Close',                        "wmctl nice-kill"),
    ('XF86WebCam',                       'camtoggle'),
    #('XF86Mail',                        ''),
    #('XF86Messenger',                   ''),
    ('XF86Search',                       "browser https://duckduckgo.com"),
    #('XF86Go',                          ''),
    #('XF86Finance',                     ''),
    #('XF86Game',                        ''),
    ('XF86Shop',                         "browser https://ebay.com"),
    ('XF86MonBrightnessDown',            'brightness -dec 15'),
    ('XF86MonBrightnessUp',              'brightness -inc 15'),
    ('shift+XF86MonBrightnessDown',      'brightness -dec 1'),
    ('shift+XF86MonBrightnessUp',        'brightness -inc 1'),
    ('XF86AudioMedia',                   'cmus-tmux-st'),
    ('XF86Display',                      'dmenudisplay'),
    #('XF86KbdLightOnOff',               ''),
    #('XF86KbdBrightnessDown',           ''),
    #('XF86KbdBrightnessUp',             ''),
    #('XF86Reply',                       ''),
    #('XF86MailForward',                 ''),
    #('XF86Save',                        ''),
    ('XF86Documents',                    "theterm lf \"$HOME/Documents\""),
    #('XF86Battery',                     ''),
    #('XF86Bluetooth',                   ''),
    ('XF86WLAN',                         'sudo -A systemctl restart NetworkManager'),

    # PERSONAL BINDINGS ------------------------------------------------------

    # TODO: move to personal

    ('super+shift+v', '/mnt/hdd1/Private/m-launcher.sh'),
    ('super+semicolon', "edit \"$HOME/Dropbox/orgmode/TODO.org\""),
    ('super+shift+semicolon', 'calendar')
]
