#!/bin/python3

import sh
import os

HOME = os.getenv("HOME")
WINDOW_MANAGER = os.getenv("WINDOW_MANAGER")

class CMD:
    pass

class WorkspaceCMD(CMD):
    def __init__(self, cmd):
        self.cmd = cmd

    def get(self, ws=None):
        if ws is None:
            ws = "{1-9,10}"
        elif ws == "0":
            ws = "10"
        return self.cmd.replace("{WS}", ws)

class MoveCMD(CMD):
    def __init__(self, cmd, directions):
        self.cmd = cmd
        self.directions = directions

    def get(self, d=None):
        if d is None:
            d = "{" + self.directions + "}"
        else:
            dirs = self.directions.split(",")
            d = d.lower()
            if d == "left":
                d = dirs[0]
            elif d == "right":
                d = dirs[1]
            elif d == "up":
                d = dirs[2]
            elif d == "down":
                d = dirs[3]
        return self.cmd.replace("{D}", d)

commands = {
    "i3": {
        'fullscreen': 'i3-msg fullscreen toggle',
        'float': 'i3-msg floating toggle',
        'stick': 'i3-msg sticky toggle',
        'split': 'i3-msg split t',
        'float_focus': 'i3-msg focus mode_toggle',
        'container_focus_parent': 'i3-msg focus parent',
        'container_focus_child': 'i3-msg focus child',
        'window_close': 'i3-msg kill',
        'window_focus': MoveCMD('i3-msg focus {D}', 'left,right,up,down'),
        'window_move': MoveCMD('i3-msg move {D}', 'left,right,up,down'),
        'window_resize': MoveCMD('i3-msg resize {D} 10 px or 10 ppt', 'shrink width,grow width,shrink height,grow height'),
        'window_resize_tiny': MoveCMD('i3-msg resize {D} 1 px or 1 ppt', 'shrink width,grow width,shrink height,grow height'),
        'workspace': 'i3-msg workspace',
        'workspace_num': WorkspaceCMD('i3-msg workspace {WS}'),
        'workspace_move': WorkspaceCMD('i3-msg move container to workspace {WS}'),
        'workspace_move_go': WorkspaceCMD('w={WS}; i3-msg move container to workspace $w\\\\; workspace $w'),
        'workspace_next': 'i3-msg workspace next',
        'workspace_prev': 'i3-msg workspace prev',
        'workspace_monitor_next': 'i3-msg move workspace to output right',
        'restart': 'i3-msg restart; pkill -USR1 -x sxhkd',
        'kill': 'i3-msg exit'
    },
    "bspwm": {
        'fullscreen': 'bspc node -t ~fullscreen',
        'float': 'bspc node -t ~floating',
        'stick': 'bspc node -s sticky',
        'split': ':', # TODO
        'float_focus': ':', # TODO
        'container_focus_parent': ':', # TODO
        'container_focus_child': ':', # TODO
        'window_close': 'bspc node -c', # -k for kill
        'window_focus': MoveCMD('bspc node -f {D}', 'west,east,north,south'),
        'window_move': MoveCMD('bspc node -s {D}', 'west,east,north,south'),
        'window_resize': MoveCMD('s=30; bspc node -z {D}', 'right -$s 0,right $s 0,bottom 0 -$s,bottom 0 $s'),
        'window_resize_tiny': MoveCMD('s=1; bspc node -z {D}', 'right -$s 0,right $s 0,bottom 0 -$s,bottom 0 $s'),
        'workspace': 'bspc desktop -f',
        'workspace_num': WorkspaceCMD('bspc desktop -f {WS}'),
        'workspace_move': WorkspaceCMD('bspc node -d {WS}'),
        'workspace_move_go': WorkspaceCMD('w={WS}; bspc node -d $w && bspc desktop -f $w'),
        'workspace_next': 'bspc desktop -f next',
        'workspace_prev': 'bspc desktop -f prev',
        'workspace_monitor_next': ':', # TODO
        'restart': 'bspc wm -r',
        'kill': 'bspc quit'
    }
}[WINDOW_MANAGER]

def get_cmd(args):
    if isinstance(args, str):
        args = [args]
    if len(args) > 0 and args[0] in commands:
        cmd = commands[args[0]]
        if isinstance(cmd, str):
            return cmd
        elif isinstance(cmd, CMD):
            if len(args) == 1:
                return cmd.get()
            elif len(args) == 2:
                if isinstance(cmd, MoveCMD):
                    ok = args[1] in ["left", "right", "up", "down"]
                elif isinstance(cmd, WorkspaceCMD):
                    ok = True
                else:
                    ok = False
                if ok:
                    return cmd.get(args[1])
                else:
                    print("ERROR: invalid argument")
                    return None
            else:
                print("ERROR: too many arguments")
                return None
    else:
        print("ERROR: unknown command. Enter one of the following commands:")
        for cmd in commands:
            print(cmd)
        return None

def nice_kill():
    try:
        sh.theterm("--kill-window")
    except sh.ErrorReturnCode_1:
        os.system(commands["window_close"])
    except sh.ErrorReturnCode_2:
        pass
    
def window_menu():
    cmds = ["Fullscreen", "Float", "Stick", "Close"]
    title = sh.xdotool("getactivewindow", "getwindowname").strip()
    cmd = sh.menu_interface(sh.echo("\n".join(cmds)),
                            "-p", title).strip()
    if cmd == "Close":
        nice_kill()
    elif cmd in cmds:
        os.system(commands[cmd.lower()])
    
def run(args):
    if len(args) > 0:
        if args[0] == "ls":
            for cmd in commands:
                print(cmd)
        elif args[0] == "nice-kill":
            nice_kill()
        elif args[0] == "window-menu":
            window_menu()
        elif args[0] == "show":
            cmd = get_cmd(args[1:])
            if cmd is not None:
                print(cmd)
        else:
            cmd = get_cmd(args)
            if cmd is not None:
                os.system(cmd)
