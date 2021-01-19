#!/bin/python3

import sh
import os
from sys import argv
from wmctl import get_cmd as wmcmd

HOME = os.getenv("HOME")
TERMINAL = os.getenv("TERMINAL")
BROWSER = os.getenv("BROWSER")

class Binding:
    def __init__(self, doc, keys, cmd):
        self.doc  = doc
        self.keys = keys
        self.cmd  = cmd

def bind(doc, keys, cmd):
    return Binding(doc, keys, cmd)

def bindhidden(keys, cmd):
    return Binding(None, keys, cmd)

bindings = [
    # WM BINDINGS ------------------------------------------------------------

    bind('Close focused program',
         'super+q', "wmctl nice-kill"),

    bind('Close focused window keeping tmux sessions',
         'super+shift+q', wmcmd("window_close")),

    bind('Ignore the tmux session (if is) and kill focused window',
         'super+control+q', "theterm --tmux-ignore && " + wmcmd("window_close")),

    bind('Enter fullscreen mode for the focused container',
         'super+f', wmcmd("fullscreen")),

    bind('Toggle tiling / floating',
         'super+t', wmcmd("float")),

    bind('Toggle sticky window',
         'super+shift+t', wmcmd("stick")),

    bind('Toggle split',
         'super+shift+slash', wmcmd("split")),

    bind('Change focus between tiling / floating windows',
         'super+slash', wmcmd("float_focus")),

    bind('Focus the parent container',
         'super+a', wmcmd("container_focus_parent")),

    bind('Focus the child container',
         'super+shift+a', wmcmd("container_focus_child")),

    bind('Change focus',
         'super+{Left,Right,Up,Down}', wmcmd("window_focus")),

    bind('Move focused window',
         'super+shift+{Left,Right,Up,Down}', wmcmd("window_move")),

    bind('Resize window',
         'super+ctrl+{Left,Right,Up,Down}', wmcmd("window_resize")),

    bind('Resize window (a little bit)',
         'super+shift+ctrl+{Left,Right,Up,Down}', wmcmd("window_resize_tiny")),

    bind('Switch to workspace',
         'super+{1-9,0}', wmcmd("workspace_num")),

    bind('Move focused container to workspace',
         'super+ctrl+{1-9,0}', wmcmd("workspace_move")),

    bind('Move focused container to workspace and go there',
         'super+shift+{1-9,0}', wmcmd("workspace_move_go")),

    bind('Move to next workspace',
         'super+Tab', wmcmd("workspace_next")),

    bind('Move to previous workspace',
         'super+shift+Tab', wmcmd("workspace_prev")),

    bind('Move workspace to next monitor',
         'super+ctrl+p', wmcmd("workspace_monitor_next")),

    bind('Restart window manager',
         'super+shift+r', wmcmd("restart")),

    # GENERAL BINDINGS -------------------------------------------------------

    bind('Start a terminal',
         'super+Return',            'theterm'),
    bind('Start a terminal with opposite split',
         'super+shift+Return',      wmcmd("split") + "; theterm"),
    bind('Start a terminal (without tmux)',
         'super+ctrl+Return',       f"{TERMINAL} bash"),
    bind('Start a terminal with opposite split (without tmux)',
         'super+shift+ctrl+Return', wmcmd("split") + f"; {TERMINAL} bash"),

    bind('Start file manager',
         'super+apostrophe',       'theterm lf'),
    bind('Start file manager with opposite split',
         'super+shift+apostrophe', wmcmd("split") + "; theterm lf"),

    bind('Empty window',
         'super+e', 'empty'),
    bind('Empty window with opposite split',
         'super+shift+e', wmcmd("split") + "; empty"),

    bind('Start the program launcher',
         'super+d', 'launcher'),

    bind('Switch language',
         'super+space', 'lang tog'),

    bind('Switch language (extended)',
         'super+shift+space', 'lang tog -e'),

    bind('Toggle on-screen keyboard',
         'super+k', 'pkill onboard || onboard'),

    bind('Open the internet browser',
         'super+b', BROWSER),

    bind('Open calculator',
         'super+equal', 'calc-floating'),

    bind('Open tiny camera',
         'super+minus', 'tiny-camera'),

    bind('Lock screen',
         'super+l',       'lockscreen'),
    bind('Power options',
         'super+x',       'dmenupower'),

    bind('Mount a drive',
         'super+m',       'dmenumount'),

    bind('Display options',
         'super+p',       'dmenudisplay'),
    bind('Reset display options',
         'super+shift+p', 'dmenudisplay -d'),

    bind('Clipboard manager',
         'super+c', 'clipmenu'),

    bind('Common words (copy to clipboard)',
         'super+w', 'dmenuwords'),

    bind('Unicode characters (copy to clipboard)',
         'super+u', 'dmenuunicode'),

    bind('Get the bibliography or PDF from the current window',
         'super+r', 'getbib'),

    bind('Youtube stuff',
         'super+y', 'dmenuyoutube'),

    bind('Help (based on copied term)',
         'super+h', 'dmenuwhat'),

    bind('Network manager menu',
         'super+n', 'networkmanager_dmenu'),

    bind('Togggle opacity of current window',
         'super+o', 'toggle-opacity'),

    bind('Toggle notifications',
         'super+i', 'notiftog'),
    bind('Notifications pop history',
         'super+ctrl+i',  'dunstctl history-pop'),
    bind('Close all notifications',
         'super+shift+i', 'dunstctl close-all'),

    bind('Take a screenshot',
         'Print',            'screenshot'),
    bind('Take a screenshot to clipboard',
         'ctrl+Print',       'screenshot -c'),
    bind('Take a screenshot of area',
         'shift+Print',      'screenshot -a'),
    bind('Take a screenshot of area to clipboard',
         'shift+ctrl+Print', 'screenshot -a -c'),
    bind('Take a screenshot of current window',
         'alt+Print',      'screenshot -w'),
    bind('Take a screenshot of current window to clipboard',
         'alt+ctrl+Print', 'screenshot -w -c'),

    bind('¯\_(ツ)_/¯',
         'super+backslash',       'lolcowforune'),
    bind('¯\_(ö)_/¯',
         'super+shift+backslash', 'lolcowforune -p'),

    bind('Jump to quick command',
         'super+j',      'quickcmd'),
    bind('Edit to quick command',
         'super+ctrl+j', 'quickcmd -e'),

    bind('Show shortcuts help screen',
         'super+F1', f"theterm '\"{__file__}\" -d | less'"),

    bind('Show the system monitor',
         'super+grave', wmcmd("workspace") + " \\#; system-monitor -1"),

    # XF86 KEYS BINDINGS -----------------------------------------------------

    bindhidden('XF86AudioMute',                    'audioctl mute'),
    bindhidden('XF86AudioLowerVolume',             'audioctl down 5'),
    bindhidden('XF86AudioRaiseVolume',             'audioctl up   5'),
    bindhidden('super+XF86AudioMute',              'audioctl pause'),
    bindhidden('super+XF86AudioLowerVolume',       'audioctl prev'),
    bindhidden('super+XF86AudioRaiseVolume',       'audioctl next'),
    bindhidden('super+shift+XF86AudioLowerVolume', 'audioctl back    10'),
    bindhidden('super+shift+XF86AudioRaiseVolume', 'audioctl forward 10'),
    bindhidden('XF86AudioNext',                    'audioctl next'),
    bindhidden('XF86AudioPlay',                    'audioctl pause'),
    bindhidden('XF86AudioPrev',                    'audioctl prev'),
    bindhidden('XF86AudioStop',                    'audioctl stop'),
    bindhidden('XF86AudioRewind',                  'audioctl back    10'),
    bindhidden('XF86AudioForward',                 'audioctl forward 10'),
    #bindhidden(XF86AudioRecord ,                  ''),
    bindhidden('XF86PowerOff',                     'dmenupower'),
    #bindhidden('XF86Copy',                        ''),
    #bindhidden('XF86Open',                        ''),
    #bindhidden('XF86Paste',                       ''),
    #bindhidden('XF86Cut',                         ''),
    #bindhidden('XF86MenuKB',                      ''),
    bindhidden('XF86Calculator',                   'calc-float'),
    #bindhidden('XF86Sleep',                       '' # This binding is typically mapped by systemd automatically.),
    #bindhidden('XF86WakeUp',                      ''),
    bindhidden('XF86Explorer',                     'theterm lf'),
    #bindhidden('XF86Send',                        ''),
    #bindhidden('XF86Xfer',                        ''),
    bindhidden('XF86WWW',                          BROWSER),
    #bindhidden('XF86DOS',                         ''),
    bindhidden('XF86ScreenSaver',                  'lockscreen'),
    #bindhidden('XF86RotateWindows',               ''),
    #bindhidden('XF86TaskPane',                    ''),
    #bindhidden('XF86Favorites',                   ''),
    bindhidden('XF86MyComputer',                   'theterm lf'),
    #bindhidden('XF86Back',                        ''),
    #bindhidden('XF86Forward',                     ''),
    bindhidden('XF86Eject',                        'dmenuumount'),
    #bindhidden('XF86Phone',                       ''),
    #bindhidden('XF86Tools',                       ''),
    bindhidden('XF86HomePage',                     f"{BROWSER} https://www.duckduckgo.com"),
    bindhidden('XF86Reload',                       'restart'),
    #bindhidden('XF86ScrollUp',                    ''),
    #bindhidden('XF86ScrollDown',                  ''),
    #bindhidden('XF86New',                         ''),
    #bindhidden('XF86LaunchA',                     ''),
    #bindhidden('XF86LaunchB',                     ''),
    #bindhidden('XF86Launch2',                     ''),
    #bindhidden('XF86Launch3',                     ''),
    #bindhidden('XF86Launch4',                     ''),
    #bindhidden('XF86Launch5',                     ''),
    #bindhidden('XF86Launch6',                     ''),
    #bindhidden('XF86Launch7',                     ''),
    #bindhidden('XF86Launch8',                     ''),
    #bindhidden('XF86Launch9',                     ''),
    #bindhidden('XF86AudioMicMute',                ''),
    bindhidden('XF86TouchpadToggle',               'toggletouchpad'),
    bindhidden('XF86TouchpadOn',                   'synclient TouchpadOff=0'),
    bindhidden('XF86TouchpadOff',                  'synclient TouchpadOff=1'),
    bindhidden('XF86Suspend',                      'lockscreen'),
    bindhidden('XF86Close',                        "wmctl nice-kill"),
    bindhidden('XF86WebCam',                       'camtoggle'),
    #bindhidden('XF86Mail',                        ''),
    #bindhidden('XF86Messenger',                   ''),
    bindhidden('XF86Search',                       f"{BROWSER} https://duckduckgo.com"),
    #bindhidden('XF86Go',                          ''),
    #bindhidden('XF86Finance',                     ''),
    #bindhidden('XF86Game',                        ''),
    bindhidden('XF86Shop',                         f"{BROWSER} https://ebay.com"),
    bindhidden('XF86MonBrightnessDown',            'brightness -dec 15'),
    bindhidden('XF86MonBrightnessUp',              'brightness -inc 15'),
    bindhidden('shift+XF86MonBrightnessDown',      'brightness -dec 5'),
    bindhidden('shift+XF86MonBrightnessUp',        'brightness -inc 5'),
    bindhidden('XF86AudioMedia',                   'cmus-tmux-st'),
    bindhidden('XF86Display',                      'dmenudisplay'),
    #bindhidden('XF86KbdLightOnOff',               ''),
    #bindhidden('XF86KbdBrightnessDown',           ''),
    #bindhidden('XF86KbdBrightnessUp',             ''),
    #bindhidden('XF86Reply',                       ''),
    #bindhidden('XF86MailForward',                 ''),
    #bindhidden('XF86Save',                        ''),
    bindhidden('XF86Documents',                    f"theterm lf '{HOME}/Documents'"),
    #bindhidden('XF86Battery',                     ''),
    #bindhidden('XF86Bluetooth',                   ''),
    bindhidden('XF86WLAN',                         'sudo -A systemctl restart NetworkManager'),

    # PERSONAL BINDINGS ------------------------------------------------------

    # TODO: move to personal

    bindhidden('super+shift+v', '/mnt/hdd1/Private/m-launcher.sh'),
    bindhidden('super+semicolon', f"emx t '{HOME}/Dropbox/orgmode/TODO.org'"),
    bindhidden('super+shift+semicolon', 'calendar')
]

def get_doc():
    for b in bindings:
        if b.doc is not None:
            yield ('%-40s: %s' % (b.keys, b.doc))

def run(keys):
    for b in bindings:
        if b.keys == keys:
            os.system(b.cmd)

def gen_sxhkdrc():
    with open(f"{HOME}/.config/sxhkd/sxhkdrc", "w") as outfile:
        outfile.write("# DO NOT EDIT!\n")
        outfile.write(f"# Generated by %s at %s\n" % (__file__, sh.date().strip()))
        for b in bindings:
            if b.doc is not None:
                outfile.write("# %s\n" % b.doc)
            outfile.write("%s\n\t%s\n\n" % (b.keys, b.cmd))
    sh.pkill("-USR1", "-x", "sxhkd")
            
            
def main(args):
    if len(args) > 0:
        if args[0] == "-d":
            for d in get_doc():
                print(d)
        elif args[0] == "-r":
            run(args[1])
        elif args[0] == "-g":
            gen_sxhkdrc()

if __name__ == "__main__":
    main(argv[1:])
