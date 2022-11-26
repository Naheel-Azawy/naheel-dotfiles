# TODO: seperate?
# TODO: turn items to shell script functions
# python opens a shell instance, source the items script,
# and call them whenever needed.
# this also can turn it into something that everyone can use.

import sh
import os
import sys
import json
import re
import time
import datetime
import asyncio
import threading
import subprocess
import socket
import signal
import importlib
import importlib.util
import importlib.machinery

import workspace_watch as wsw
import xrandr_parse    as xrandr

try:
    # sudo pip3 install python-bidi arabic-reshaper
    import bidi.algorithm
    import arabic_reshaper
    use_arabic = True
except:
    use_arabic = False

# export FONT_SIZE='Iosevka Fixed:size=12'
env_font = os.getenv("FONT_SIZE", "monospace")
try:
    env_font_size = float(env_font.split(":size=")[1])
except:
    env_font_size = 12
icons_font_size = env_font_size * 1.333

themes = {
    "material": {
        # https://fonts.google.com/icons?selected=Material+Icons
        "icons_font": f"Material Icons:size={icons_font_size}",
        "icons": {
            "exclamation": "\ue645",
            "plug":        "\ue63c",
            "battery30":   "\uebe0",
            "battery50":   "\uebdd",
            "battery60":   "\uebd4",
            "battery90":   "\uebd2",
            "battery100":  "\ue1a4",
            "wifi1":       "\uebe4",
            "wifi2":       "\uebd6",
            "wifi3":       "\uebe1",
            "wifi4":       "\ue1d8",
            "prayer":      "\uf03d",
            "cloud":       "\ue2bd",
            "temp90":      "\uf076",
            "temp50":      "\uf076",
            "temp40":      "\uf076",
            "temp30":      "\uf076",
            "power":       "\ue8ac",
            "more":        "\ue5cf",
            "plus":        "\ue145",
            "close":       "\ue5cd",
            "keyboard":    "\ue312"
        }
    },

    "awesome": {
        # https://fontawesome.com/icons
        "icons_font": f"Font Awesome 6 Free Solid:size={icons_font_size}",
        "icons": {
            "exclamation": " ",
            "plug":        " ",
            "battery30":   "",
            "battery50":   "",
            "battery60":   "",
            "battery90":   "",
            "battery100":  "",
            "wifi1":       "",
            "wifi2":       "",
            "wifi3":       "",
            "wifi4":       "",
            "prayer":      "",
            "cloud":       "",
            "temp90":      "",
            "temp50":      "",
            "temp40":      "",
            "temp30":      "",
            "power":       "",
            "more":        "",
            "plus":        "",
            "close":       "",
            "keyboard":    ""
        }
    },

    "ascii": {
        "icons_font": None,
        "icons": {
            "exclamation": "!",
            "plug":        "~",
            "battery30":   "b",
            "battery50":   "b",
            "battery60":   "b",
            "battery90":   "b",
            "battery100":  "b",
            "wifi1":       "s",
            "wifi2":       "s",
            "wifi3":       "s",
            "wifi4":       "s",
            "prayer":      "p",
            "cloud":       "w",
            "temp90":      "t",
            "temp50":      "t",
            "temp40":      "t",
            "temp30":      "t",
            "power":       "p",
            "more":        "<",
            "plus":        "+",
            "close":       "x",
            "keyboard":    "k"
        }
    }
}

def find_theme():
    font_to_theme = {}
    for t in themes:
        if themes[t]["icons_font"] is None:
            continue
        font_to_theme[themes[t]["icons_font"].split(":")[0]] = t

    fonts_list = [l.split(":")[1].strip() for l in sh.fc_list()]
    for f in font_to_theme:
        for l in fonts_list:
            if f in l:
                return font_to_theme[f]
    return "ascii"

theme      = find_theme()
icons_font = themes[theme]["icons_font"]
icons      = themes[theme]["icons"]
background = '#dd000000'
foreground = '#ffffff'

default_items = "start workspaces program | clock | systray keyboard pray weather temperature wifi battery power"

port_file = "/tmp/.nbarport"
pid_file  = "/tmp/.nbarpid"

argv = sys.argv
HOME = os.getenv("HOME")
WINDOW_MANAGER = os.getenv("WINDOW_MANAGER")

# example: WM(lambda s: print(s)).run()
class WM:
    def __init__(self, callback):
        wm = WINDOW_MANAGER
        try:
            self.impl = wsw.init(output="lemonbar_circles_mini", onchange=callback)
        except:
            self.impl = None
        self.title = None # to be set by bar.program()
        # names to be picked for new workspaces
        self.nice_workspaces = list(range(1, 10)) + [0]
        self.nice_workspaces = list(map(lambda i: str(i), self.nice_workspaces))

    async def run(self):
        if self.impl is None:
            return
        count = 0
        while count < 10:
            try:
                await asyncio.to_thread(self.impl.run)
                break
            except Exception:
                # in case the bar started before the window manager
                await asyncio.sleep(1)

class XTitle:
    def __init__(self, callback):
        self.callback = callback

    async def run(self):
        try:
            await asyncio.to_thread(self.loop)
        except Exception:
            raise Exception(f"xtitle thread failed")

    def loop(self):
        popen = subprocess.Popen(["xtitle", "-s"],
                                 stdout=subprocess.PIPE,
                                 universal_newlines=True)
        for line in iter(popen.stdout.readline, ""):
            self.callback(line.strip())
        popen.stdout.close()
        code = popen.wait()
        if code != 0:
            raise Exception(f"xtitle exited with code {code}")

def item(period=0, big=False):
    """A decorator to simplify defining periodic functions"""
    def decorate(func):
        def wrapper(*args, **kwargs):
            if "period" in args:
                return period
            elif "name" in args:
                return func.__name__
            elif "big" in args:
                return big
            else:
                return func(*args, **kwargs)
        return wrapper
    return decorate

class BarBase:
    def __init__(self, use_ascii=False, items=None, outs=[sys.stdout], minis=[False]):
        self.server = None
        self.ws_str = None # to be set from wsw
        self.a = use_ascii
        self.wm = WM(self.run_wm_items)
        self.xtitle = XTitle(self.run_xtitle_items)

        if len(minis) != len(outs):
            minis = [False] * len(outs)
        self.outs = outs
        self.minis = minis

        if items is None:
            self.items_str = default_items
        else:
            self.items_str = items

        places = re.split(r"\s*\|\s*", self.items_str)

        self.items_map = {"l": [], "c": [], "r": []}
        for i in range(len(places)):
            place = [getattr(self, m)
                     for m in re.split(r"\s+", places[i]) if m]
            if i == 0:
                self.items_map["l"] += place
            elif i == 1:
                self.items_map["c"] += place
            else:
                self.items_map["r"] += place

        self.items = self.items_map["l"] + \
            self.items_map["c"] + \
            self.items_map["r"]

        self.last = {}
        self.running = False
        self.coroutines = []
        self.tasks = None

    def print_items(self):
        for i in self.items:
            print(i("name"), i("period"))

    def render(self):
        for i in range(len(self.outs)):
            o    = self.outs[i]
            mini = self.minis[i]
            out = ""
            if self.a:
                items_out = []
                for item in self.items:
                    content = self.last[item("name")]
                    if not content: continue
                    items_out.append(content)
                out += " | ".join(items_out)
            else:
                for place in self.items_map:
                    out += f"%{{{place}}}"
                    items_out = []
                    for item in self.items_map[place]:
                        if not mini or (mini and not item("big")):
                            content = self.last[item("name")]
                            if not content: continue
                            items_out.append(content)
                    out += "  ".join(items_out)
                out += " "

            o.write(out + "\n")
            try:
                o.flush()
            except BrokenPipeError:
                exit(0)

    def run_item(self, item):
        if item in self.items:
            self.last[item("name")] = item()

    async def run_periodic_item(self, item):
        if item not in self.items:
            return
        while self.running:
            self.run_item(item)
            self.render()
            # print(f">>>>> CALLED {item('name')}, sleeping {item('period')}\n")
            period = item("period")
            if period <= 0:
                break
            await asyncio.sleep(period)

    def run_wm_items(self, ws_str):
        self.ws_str = ws_str
        self.run_item(self.workspaces)
        self.run_item(self.program)
        self.run_item(self.add)
        self.render()

    def run_xtitle_items(self, title):
        self.wm.title = title
        self.run_item(self.program)
        self.render()

    async def handle_connection(self, reader, writer):
        data = b""
        while True:
            tmp = await reader.read(1024)
            data += tmp
            if not tmp: break
        data = data.decode().split("?")
        cmd = data[0]
        data = data[1]
        if cmd == "update":
            item = getattr(self, data)
            self.last[item("name")] = item()
            self.render()

    def init(self):
        for item in self.items:
            self.run_item(item)

    async def run(self):
        if self.running:
            return
        self.running = True
        self.init()
        self.render()
        coroutines = []

        # window manager
        if self.wm is not None:
            coroutines.append(self.wm.run())

        # xtitle
        if self.xtitle is not None:
            coroutines.append(self.xtitle.run())

        # periodic items
        for item in self.items:
            if item("period") > 0:
                coroutines.append(self.run_periodic_item(item))

        # server
        server = await asyncio.start_server(
            self.handle_connection, "localhost", 0)
        port = server.sockets[0].getsockname()[1]
        with open(port_file, "w") as f:
            f.write(str(port))
        coroutines.append(server.serve_forever())
        self.tasks = asyncio.gather(*coroutines)
        try:
            await self.tasks
        except asyncio.CancelledError:
            pass

    def stop(self):
        self.running = False
        self.tasks.cancel()

class Bar(BarBase):

    @item(big=False)
    def workspaces(self):
        if self.wm is None or self.a:
            return None
        else:
            wmcmd = self.wm.impl.workspace_cmd
            ret =  f"%{{A:{wmcmd} prev&:}}<  %{{A}}"
            ret += self.ws_str or ""
            ret += f"%{{A:{wmcmd} next&:}}  >%{{A}}"
            return ret

    @item(big=True)
    def add(self):
        if self.a or self.wm.impl is None:
            return None
        return "%{A:wm-msg workspace_new:}" + icons["plus"] + "%{A}"

    @item()
    def program(self):
        if self.wm is None or self.wm.title is None:
            return None
        # not accurate, depends on the resolution and font size, but too lazy
        if "workspaces" in self.items_str and self.wm.impl is not None:
            max_title = 50 - int(len(self.wm.impl.workspaces) * 1.5)
        else:
            max_title = 80
        title = self.wm.title
        if len(title) > max_title:
            title = title[:max_title].strip() + "…"
        if use_arabic:
            title = bidi.algorithm.get_display(
                arabic_reshaper.reshape(title))
        if self.a:
            return title
        else:
            out = ""
            if title:
                return "%{A:wm-msg window_nice_close:}" + \
                    icons["close"] + "%{A}  " + \
                    "%{A:wm-msg program-menu&:}" + title + "%{A}"
            else:
                return None

    @item(period=1, big=True)
    def clock(self):
        t = datetime.datetime.now().strftime("%a %Y.%m.%d %I:%M:%S %p")
        if self.a:
            return t
        else:
            cmd = "ndg menu --dims 68x35 --trm 'cal -y; while read -r args; do clear; cal $args; done'"
            return f"%{{A:{cmd}&:}}{t}%{{A}}"

    @item(period=3, big=True)
    def battery(self):
        try:
            acpi = sh.grep(sh.acpi("-b"), v="unavailable").split("\n")[0]
            percent = int(acpi.split(", ")[1].replace("%", ""))
            charging = "Charging" in acpi
            plugged = charging or "Not charging" in acpi
        except:
            return None

        # https://wiki.archlinux.org/title/Lenovo_ThinkPad_X1_Carbon_(Gen_10)#Performance_modes
        profile = None
        profilef = "/sys/firmware/acpi/platform_profile"
        if os.path.exists(profilef):
            try:
                with open(profilef, "r") as f:
                    profile = f.read().strip()[0]
            except:
                pass

        if self.a:
            charging = "~" if charging else ""
            return f"b{charging}{percent}%"
        else:
            out = ""
            r = "-"

            if charging:
                r = '#FFFFFF' if percent >= 99 else '#FFD700'
            elif percent <= 20:
                if percent > 10:
                    r = '#FF0000'
                else:
                    r = '#000000'
                if percent <= 15:
                    out += icons["exclamation"]

            if plugged:
                out += icons["plug"]

            if percent < 30:
                out += icons["battery30"]
            elif percent < 50:
                out += icons["battery50"]
            elif percent < 70:
                out += icons["battery60"]
            elif percent < 99:
                out += icons["battery90"]
            else:
                out += icons["battery100"]

            out += f" {percent}%%"

            if profile:
                out += profile

            if percent <= 10 and not charging:
                out = "%{B#FF0000} " + out + " %{B-}"

            cmd = "ndg menu --dims 75x3 --trm 'watch -tn 1 acpi -i'"
            out = f"%{{F{r}}}%{{A:{cmd}&:}}{out}%{{A}}%{{F-}}"

            return out

    @item(period=5, big=True)
    def wifi(self):
        try:
            with open("/proc/net/wireless") as f:
                v = re.split(r"\s+", f.read().split("\n")[2])[2]
                v = int(float(v))
                if self.a:
                    return f"s{v}%"
                else:
                    if v >= 90:
                        ic = icons["wifi4"]
                    elif v >= 60:
                        ic = icons["wifi3"]
                    elif v >= 40:
                        ic = icons["wifi2"]
                    else:
                        ic = icons["wifi1"]
                    cmd = "ndg menu --dims 120x20 --trm 'watch -ctn 1 ip --color=always a'"
                    return f"%{{A:{cmd}&:}}{ic} {v}%%%{{A}}"
        except:
            pass
        return None

    @item(period=30, big=True)
    def pray(self):
        out = os.popen("prayer --mini 2>/dev/null").read().strip()
        if not out:
            return None
        if self.a:
            return f"p{out}"
        else:
            cmd = "ndg menu --trm prayer --dims 25x8"
            return f"%{{A:{cmd}&:}} " + icons["prayer"] + \
                f" {out}%{{A}}"

    @item(period=30 * 60, big=True)
    def weather(self):
        fpath = f"{HOME}/.cache/weatherreport"
        # try:
        #     sh.curl("-s", "wttr.in?n", _out=fpath)
        # except:
        #     pass
        if not os.path.exists(fpath):
            return None

        with open(fpath, "rb") as f:
            try:
                out = f.read().decode(errors="ignore").split("\n")[3] # third line
            except:
                return None
            # remove colors https://stackoverflow.com/a/14693789/3825872
            r = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')
            out = r.sub("", out).strip()
            try:
                temp = re.search(".+ (.+) °C.*", out).group(1)
            except:
                return None
            try:
                temp = re.search(".+\((\d+)\)", temp).group(1)
            except:
                pass
            out = f"{temp}°C"

            if self.a:
                return f"w{out}"
            else:
                cmd = f"ndg menu --trm wttr --dims 63x28"
                return f"%{{A:{cmd}&:}} " + icons["cloud"] + f" {out}%{{A}}"

        return None

    @item(period=5, big=True)
    def temperature(self):
        try:
            o = json.loads(sh.sensors("coretemp-isa-0000", "-j").strip()) \
                ["coretemp-isa-0000"]["Package id 0"]
            t = float(o["temp1_input"])
            m = float(o["temp1_max"])
        except:
            return None

        percent = int((t / m) * 100)
        if percent < 70:
            return None

        if self.a:
            return f"t{int(t)}°C"
        else:
            out = ""
            if percent > 90:
                out += "%{F#FF0000}" + icons["temp90"]
            elif percent > 50:
                out += icons["temp50"]
            elif percent > 40:
                out += icons["temp40"]
            else:
                out += icons["temp30"]
            out += f" {int(t)}°C %{{F-}}"
            cmd = "ndg menu --dims 65x19 --trm 'watch -tn 1 sensors'"
            return f"%{{A:{cmd}&:}}{out}%{{A}}"

    @item()
    def start(self):
        return "%{A:ndg menu&:} START%{A}" if not self.a else None

    @item()
    def power(self):
        return "%{A:ndg menu --power&:}" + icons["power"] + \
            "%{A}" if not self.a else None

    @item()
    def systray(self):
        return "%{A:ndg systraytog&:}" + icons["more"] + \
            "%{A}" if not self.a else None

    @item(big=True)
    def donno(self):
        return "%{A:ndg menu --trm 'lolcowforune -p'&:}¯\_(ツ)_/¯%{A}" \
            if not self.a else None

    @item(big=True)
    def host(self):
        return os.uname()[1]

    @item(big=True)
    def keyboard(self):
        if self.a or self.wm.impl is None:
            return None
        try:
            # https://askubuntu.com/a/520360
            sh.grep(sh.udevadm("info", "--export-db"), "ID_INPUT_TOUCHSCREEN=1")
        except:
            # only show in touch screen devices
            return None
        return "%{A:pkill onboard || onboard &:}" + icons["keyboard"] + "%{A}"

def lemon_kill():
    if os.path.exists(pid_file):
        with open(pid_file, "r") as f:
            pid = int(f.read())
            try:
                sh.kill(pid)
            except sh.ErrorReturnCode_1:
                pass

def lemonbar():
    lemon_kill()
    with open(pid_file, "w") as f:
        f.write(str(os.getpid()))

    monitors = [o for o in xrandr.parse() if o["connected"] and o["geometry"]]

    fonts = []
    if env_font:
        fonts += ["-f", env_font]
    if icons_font is not None:
        fonts += ["-f", icons_font]
    fonts += [
        "-f", "Kawkab Mono:pixelsize=12",
        "-f", "Source Han Sans CN",
        "-f", "DejaVu Sans Mono",
    ]

    args = ["lemonbar", "-B", background, "-F", foreground, "-a", "30"] + fonts

    # map x values to geometries
    # useful when multiple monitors start at the same x
    # the smallest w will be used in this case
    x2g = {}
    for mon in monitors:
        g = mon["geometry"]
        if g['x'] in x2g:
            if x2g[g['x']]['w'] > g['w']:
                x2g[g['x']] = g
        else:
            x2g[g['x']] = g

    # start a lemonbar process for each geometry
    lemons = []
    lemons_stdin = []
    minis = []
    for g in x2g.values():
        lemonp = subprocess.Popen(args + ["-g", f"{g['w']}x+{g['x']}+{g['y']}"],
                                  stdin=subprocess.PIPE,
                                  stdout=subprocess.PIPE,
                                  universal_newlines=True)
        lemons.append(lemonp)
        lemons_stdin.append(lemonp.stdin)
        minis.append(g['w'] < g['h'])

        def lemon_output_handler():
            for line in iter(lemonp.stdout.readline, ""):
                os.system(line.strip())
            lemonp.stdout.close()

        threading.Thread(target=lemon_output_handler).start()

    # but a single thread providing inputs to lemonbars
    bar = Bar(items=None, outs=lemons_stdin, minis=minis)
    signal.signal(signal.SIGINT, lambda signal, frame: bar.stop())
    threading.Thread(target=lambda: asyncio.run(bar.run())).start()

    for l in lemons:
        l.wait()

    os.remove(pid_file)

async def async_main(args):
    if args.kill:
        lemon_kill()
    elif args.update:
        item = args.update.encode()
        with open(port_file, "r") as f:
            try:
                port = int(f.read())
                reader, writer = await asyncio.open_connection("localhost", port)
                writer.write(b"update?" + item)
                writer.close()
            except:
                print("Error finding socket port")
    elif len(args.items) > 0:
        bar = Bar(use_ascii=args.ascii, items=" ".join(args.items))
        if args.persistent:
            signal.signal(signal.SIGINT, lambda signal, frame: bar.stop())
            await bar.run()
        else:
            bar.init()
            bar.render()
    else:
        lemonbar()

def main(args):
    asyncio.run(async_main(args))
