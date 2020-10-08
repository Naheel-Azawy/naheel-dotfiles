#!/bin/python3

import i3ipc
import os
import sys
import json
import re
import time
import datetime
import threading

color_bg = "#000000"
color_bl = "#285577"
color_rd = "#900000"
color_gr = "#333333"

class WM:
    def __init__(self, callback):
        self.i3 = i3ipc.Connection()
        self.title = self.i3.get_tree().find_focused().name
        self.workspaces = self.i3.get_workspaces()
        self.callback = callback

    def on_title_change(self, caller, e):
        self.title = e.container.name
        self.callback(self)

    def on_workspace_change(self, caller, e):
        self.workspaces = self.i3.get_workspaces()
        self.callback(self)

    def run(self):
        self.i3.on('workspace::focus', self.on_workspace_change)
        self.i3.on('window::title',    self.on_title_change)
        self.i3.on('window::focus',    self.on_title_change)
        self.i3.on('window::urgent',   self.on_workspace_change)
        #self.i3.on('ipc-shutdown',     lambda e: print("bye"))

        self.i3.main()

    def json(self):
        workspaces = {}
        for w in self.workspaces:
            workspaces[w.name] = {
                "visible": w.visible,
                "focused": w.focused,
                "urgent":  w.urgent
            }
        return json.dumps({
            "title": self.title,
            "workspaces": workspaces
        })

    def lemon(self):
        out = ""
        for w in self.workspaces:
            if w.focused:
                out += f"%{{F#ffffff B{color_bl}}}"
            elif w.visible:
                out += f"%{{F#ffffff B{color_gr}}}"
            elif w.urgent:
                out += f"%{{F#ffffff B{color_rd}}}"
            else:
                out += f"%{{F#888888 B-}}"
            onclick = f"i3-msg workspace '{w.name}' >/dev/null"
            out += f"%{{A:{onclick}:}} "
            out += w.name
            #.encode(encoding="ascii",errors="backslashreplace").decode()
            out += " %{A}"
        out += "%{F- B-}" # reset the colors
        return out

class Bar:
    def __init__(self, use_ascii=False):
        self.a = use_ascii
        self.wm = WM(self.run_wm_items)

        self.items_str = "workspaces | clock | systray donno lang pray weather temperature wifi battery power"

        places = re.split(r"\s*\|\s*", self.items_str)
        if len(places) != 3:
            raise Exception("Must have exactly 3 pipes")

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

    def workspaces(self, arg=None):
        if arg == "period":
            return 0

        return self.wm.lemon()

    def program(self, arg=None):
        if arg == "period":
            return 0

        # TODO: title is not cleared when there is no focused window
        title = self.wm.title
        if len(title) > 40:
            title = title[:40] + "..."

        if self.a:
            return title
        else:
            out = ""
            if title:
                out += "%{A:i3-msg kill >/dev/null:}%{A} "
            out += title
            return out

    def clock(self, arg=None):
        if arg == "period":
            return 1

        t = datetime.datetime.now().strftime("%a %Y-%m-%d %I:%M:%S %p")
        if self.a:
            return t
        else:
            cmd = "theterm -a '-c __floatme__ -g 70x35' 'cal -y && read -p \"\"'"
            return f"%{{A:{cmd}&:}}{t}%{{A}}"

    def battery(self, arg=None):
        if arg == "period":
            return 3

        acpi = os.popen("acpi -b").read().strip()
        percent = int(acpi.split(", ")[1].replace("%", ""))
        charging = "Discharging" not in acpi

        if self.a:
            charging = "~" if charging else ""
            return charging + percent + "%"
        else:
            out = ""
            r = "-"
            
            if charging:
                r = '#00FF00' if percent >= 99 else '#FFD700'
                out += f"%{{F{r}}} "
            elif percent <= 20:
                r = '#FF0000'
                if percent <= 5:
                    out += f"%{{F{r}}} "

            if percent < 50:
                out += ""
            elif percent < 60:
                out += ""
            elif percent < 90:
                out += ""
            else:
                out += ""

            out += f"%{{F-}} {percent}%"
            out = f"%{{A:echo battery:}}{out}%{{A}}"
            return out

    def wifi(self, arg=None):
        if arg == "period":
            return 5

        with open("/proc/net/wireless") as f:
            v = re.split(r"\s+", f.read().split("\n")[2])[2]
            v = int(float(v))

            if self.a:
                return f"{v}%"
            else:
                return f"%{{A:networkmanager_dmenu&:}} {v}%%{{A}}"

        return None

    def lang(self, arg=None):
        if arg == "period":
            return 3 # TODO

        out = os.popen(f"lang-toggle -v").read().strip()
        if self.a:
            return out
        else:
            return f"%{{A:lang-toggle >/dev/null:}}{out}%{{A}}"

    def pray(self, arg=None):
        if arg == "period":
            return 30

        out = os.popen("theprayer n").read().strip()
        if not out:
            return None

        if self.a:
            return out
        else:
            cmd = "theterm -a '-c __floatme__ -g 25x8' 'theprayer && read -p \"\"'"
            return f"%{{A:{cmd}&:}}  {out}%{{A}}"

    def weather(self, arg=None):
        if arg == "period":
            return 30 * 60

        f = os.getenv("HOME") + "/.cache/weatherreport"
        with open(f) as f:
            out = f.read().split("\n")[3] # third line
            # remove colors https://stackoverflow.com/a/14693789/3825872
            r = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')
            out = r.sub("", out).strip()
            out = out[-15:].strip() # take last few chars

            if self.a:
                return out
            else:
                cmd = "theterm -a '-c __floatme__ -g 63x38' 'weather-update & head -n 37 ~/.cache/weatherreport && read -p \"\"'"
                return f"%{{A:{cmd}&:}}  {out}%{{A}}"

        return None

    def temperature(self, arg=None):
        if arg == "period":
            return 5

        o = json.loads(os.popen(f"sensors coretemp-isa-0000 -j").read()) \
            ["coretemp-isa-0000"]["Package id 0"]
        t = float(o["temp1_input"])
        m = float(o["temp1_max"])

        if self.a:
            return f"{int(t)}°C"
        else:
            percent = int((t / m) * 100)
            out = ""
            if percent > 90:
                out += "%{F#FF0000} "
            elif percent > 50:
                out += ""
            elif percent > 40:
                out += ""
            else:
                out += ""
            out += f"%{{F-}} {int(t)}°C"
            cmd = "theterm -a '-c __floatme__ -g 65x19' 'watch -tn 1 sensors'"
            return f"%{{A:{cmd}&:}}{out}%{{A}}"

    def close(self, arg=None):
        if arg == "period":
            return 0

        return "%{A:i3-msg kill >/dev/null:}%{A}"

    def power(self, arg=None):
        if arg == "period":
            return 0

        return "%{A:dmenupower:}%{A}"

    def systray(self, arg=None):
        if arg == "period":
            return 0

        return "%{A:toggle-systray&:}%{A}"

    def donno(self, arg=None):
        if arg == "period":
            return 0

        return "%{A:theterm 'lolcowforune -p'&:}¯\_(ツ)_/¯%{A}"

    def render(self):
        out = ""

        for place in self.items_map:
            out += f"%{{{place}}}"
            items_out = []
            for item in self.items_map[place]:
                items_out.append(self.last[item.__name__])
            out += "  ".join(items_out)

        out += " "
        
        print(out)
        sys.stdout.flush()

    def run_and_sleep(self, item):
        if item not in self.items:
            return

        while self.running:
            self.last[item.__name__] = item()
            self.render()
            #print(f">>>>> CALLED {item.__name__}, sleeping {item('period')}\n")
            period = item("period")
            if period <= 0:
                break
            time.sleep(period)

    def run_wm_items(self, wm):
        self.run_and_sleep(self.workspaces)
        self.run_and_sleep(self.program)

    def run(self):
        self.running = True

        # init calls
        for item in self.items:
            self.last[item.__name__] = item()
        self.render()

        # async calls
        threading.Thread(target=self.wm.run).start()
        for item in self.items:
            if item("period") > 0:
                # periodic items run on their own thread
                threading.Thread(target=lambda: self.run_and_sleep(item)).start()

def lemonbar():
    bin = os.path.abspath(__file__)

    # fonts = ["Iosevka Fixed",
    #          "DejaVu Sans Mono",
    #          "Source Han Sans CN",
    #          "Font Awesome 5 Free",
    #          "Font Awesome 5 Brands",
    #          "Font Awesome 5 Free Solid"]
    fonts = ["Iosevka Fixed",
             "Source Han Sans CN",
             "Font Awesome 5 Free Solid"]
    awesome_size = 20
    background = '#000000'
    foreground = '#ffffff'

    tmp = ""
    for f in fonts:
        if "Awesome" in f:
            f += f":pixelsize={awesome_size}"
        tmp += f"-f '{f}' "
    fonts = tmp

    os.system(f"""python3 '{bin}' feed |
    lemonbar -p {fonts} -B '{background}' -F '{foreground}' -a 30 | sh""")

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1]:
        arg = sys.argv[1]
    else:
        arg = None

    if arg == "feed":
        Bar(use_ascii=False).run()
    else:
        lemonbar()

#WM(lambda wm: print(wm.json())).run()
