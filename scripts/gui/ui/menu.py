
# non-portable parts: $TERMINAL, $DOTFILES_DIR/icons, systemctl, wm-msg end, ndg lockscreen

import os
import sys
import subprocess
import argparse
import json
from dataclasses import dataclass

import warnings
warnings.filterwarnings("ignore")

import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, Gdk, GdkPixbuf, Vte, Pango, GLib

NAME = "ndg-menu"

CSS = b"""
#maincontainer {
    background-color: rgba(0, 0, 0, 0.5);
}

#searchbox {
    background: none;
    border-color: #999;
    color: #ccc;
    margin-top: 20px;
    margin-bottom: 20px;
    margin-left: 32px;
    margin-right: 32px;
}

flowboxchild {
    transition-duration: 200ms;
    background-color: rgba(0, 0, 0, 0);
    border: 1px solid rgba(0, 0, 0, 0);
    box-shadow: none;
    color: #aaa;
    outline: none; /* https://askubuntu.com/a/1141668 */
}
flowboxchild:selected {
    background-color: rgba(255, 255, 255, 0.2);
    border: 1px solid rgba(255, 255, 255, 0.5);
    color: #fff;
}

messagedialog {
    background-color: #000;
}
messagedialog button {
    background: black;
    color: white;
    text-shadow: none;
}
messagedialog button:focus {
    background: red;
    color: black;
    text-shadow: none;
}
"""

@dataclass
class Geometry:
    x: int
    y: int
    w: int
    h: int

def display_geometry(win):
    """
    Returns geometry of currently focused display
    :return: (x, y, width, height)
    """
    screen = win.get_screen()
    try:
        active = screen.get_active_window() # FIXME: depricated
        if active:
            display_number = screen.get_monitor_at_window(active)
        else:
            # Could not detect active window; use first monitor
            display_number = 0
        rectangle = screen.get_monitor_geometry(display_number)
        return Geometry(rectangle.x, rectangle.y, rectangle.width, rectangle.height)
    except:
        return None

def data_dirs():
    paths = [os.path.expanduser('~/.local/share'), "/usr/share", "/usr/local/share"]
    if "XDG_DATA_DIRS" in os.environ:
        dirs = os.environ["XDG_DATA_DIRS"]
        if dirs:
            dirs = dirs.split(":")
            for d in dirs:
                while d.endswith("/"):
                    d = d[:-1]
                if d not in paths:
                    paths.append(d)
    return paths

msg = None

cache_dir = os.getenv("XDG_CACHE_HOME", os.path.expanduser("~/.cache"))
if not os.path.exists(cache_dir):
    os.makedirs(cache_dir)
cache_file_desktops = os.path.join(cache_dir, NAME + ".json")

def main(args):
    win = MainWindow(args)
    win.set_resizable(False)
    win.show_all()
    win.set_resizable(True) # to stay floating in a tiling wm

    Gtk.main()

def power_entries():
    ic = os.getenv("DOTFILES_DIR") + "/icons"
    return [
        Item("Sleep",     "systemctl suspend",   f"{ic}/power-sleep.svg",     confirm=False),
        Item("Shutdown",  "systemctl poweroff",  f"{ic}/power-shutdown.svg",  confirm=True),
        Item("Restart",   "systemctl reboot",    f"{ic}/power-restart.svg",   confirm=True),
        Item("Logout",    "wm-msg end",          f"{ic}/power-logout.svg",    confirm=True),
        Item("Lock",      "ndg lockscreen",      f"{ic}/power-lock.svg",      confirm=False),
        Item("Hibernate", "systemctl hibernate", f"{ic}/power-hibernate.svg", confirm=True),
    ]

def json_str_entries(jstr):
    entries = []
    for o in json.loads(jstr):
        entries.append(Item.from_dict(o))
    return entries

def json_file_entries(jfile):
    entries = []
    try:
        with open(jfile, "r") as f:
            for o in json.load(f):
                entries.append(Item.from_dict(o))
            return entries
    except Exception as e:
        print(f"Failed reading json file '{jfile}'")
        print(e)

def desktop_entries(update=False, ddir=None):
    all_apps = []
    if os.path.exists(cache_file_desktops) and not update and not ddir:
        try:
            with open(cache_file_desktops, "r") as f:
                for o in json.load(f):
                    all_apps.append(Item.from_dict(o))
                return all_apps
        except:
            print("Failed reading cache")
            pass

    def desktop_parse_bool(line):
        try:
            return line.split('=')[1].strip().lower() == "true"
        except:
            return False

    locale_str = "" # maybe add later
    apps = []
    paths = ([os.path.join(p, "applications") for p in data_dirs()])
    if ddir:
        if ":" not in ddir:
            paths = [ddir]
        else:
            paths = ddir.split(':')
    for path in paths:
        if os.path.exists(path):
            for f in os.listdir(path):
                app = Item()
                try:
                    with open(os.path.join(path, f)) as d:
                        lines = d.readlines()
                        read_me = True

                        for line in lines:
                            if line.startswith("["):
                                read_me = line.strip() == "[Desktop Entry]"
                                continue
                            if read_me:
                                loc_name = 'Name{}='.format(locale_str)

                                if line.startswith('NoDisplay='):
                                    if desktop_parse_bool(line):
                                        app = None
                                        break
                                    continue

                                if line.startswith('OnlyShowIn='):
                                    showin = line.split('=')[1].strip()
                                    if showin != "": # TODO: allow some?
                                        app = None
                                        break
                                    continue

                                if line.startswith('Name='):
                                    app.name = line.split('=')[1].strip()
                                    continue

                                if line.startswith(loc_name):
                                    app.name = line.split('=')[1].strip()
                                    continue

                                loc_comment = 'Comment{}='.format(locale_str)

                                if line.startswith('Comment='):
                                    app.comment = line.split('=')[1].strip()
                                    continue

                                if line.startswith(loc_comment):
                                    app.comment = line.split('=')[1].strip()
                                    continue

                                if line.startswith('Exec='):
                                    cmd = line.split('=')[1:]
                                    c = '='.join(cmd)
                                    app.exec = c.strip()
                                    if '%' in app.exec:
                                        app.exec = app.exec.split('%')[0].strip()
                                    continue

                                if line.startswith('Icon='):
                                    app.icon = line.split('=')[1].strip()

                                if line.startswith('Terminal='):
                                    app.terminal = desktop_parse_bool(line)

                        if app and app.name and app.exec and app.icon:
                            # avoid adding twice
                            found = False
                            for item in apps:
                                if item.name == app.name and item.exec == app.exec:
                                    found = True
                            if not found:
                                apps.append(app)

                except Exception as e:
                    print(e)

    apps = sorted(apps, key=lambda x: x.name.upper())
    for app in apps:
        all_apps.append(app)

    if not ddir:
        with open(cache_file_desktops, "w") as f:
            json.dump(apps, f, indent=4, default=lambda o: o.to_dict())

    return all_apps

class MainWindow(Gtk.Window):
    def __init__(self, args):
        Gtk.Window.__init__(self, Gtk.WindowType.TOPLEVEL)
        self.args = args

        screen = Gdk.Screen.get_default()
        provider = Gtk.CssProvider()
        try:
            if self.args.css:
                provider.load_from_path(self.args.css)
            else:
                provider.load_from_data(CSS)
            Gtk.StyleContext.add_provider_for_screen(
                screen, provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)
        except Exception as e:
            print(e)

        screen = Gdk.Screen.get_default()
        provider = Gtk.CssProvider()
        style_context = Gtk.StyleContext()
        style_context.add_provider_for_screen(
            screen, provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)

        self.set_skip_pager_hint(True)

        if self.args.prompt:
            self.set_title(self.args.prompt)
        elif self.args.trm:
            self.set_title(self.args.trm.split(" ")[0])
        elif self.args.dmenu:
            self.set_title("Menu")
        elif self.args.power:
            self.set_title("Power options")
        else:
            self.set_title("Applications")
        self.set_role(NAME)

        self.connect("destroy", Gtk.main_quit)
        self.connect("key-release-event", self.on_key_release)
        self.connect("focus-out-event", self.on_focus_out)

        # Credits for transparency go to KurtJacobson:
        # https://gist.github.com/KurtJacobson/374c8cb83aee4851d39981b9c7e2c22c
        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        if visual and screen.is_composited():
            self.set_visual(visual)
        self.set_app_paintable(True)

        geometry = display_geometry(self)
        if self.args.fullscreen:
            self.fullscreen()

        self.items_cont = None
        self.search_box = None
        self.trm = None

        main_container = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        main_container.set_property("name", "maincontainer")

        if self.args.trm:
            main_box = self.mk_trm_box()
        else:
            main_box = self.mk_items_cont_box()

        main_container.pack_start(main_box, True, True, 0)
        self.add(main_container)

        self.set_position(Gtk.WindowPosition.CENTER)
        self.set_keep_above(True)

        if self.trm and self.args.dims:
            dims = self.args.dims.split("x")
            self.trm.set_size(int(dims[0]), int(dims[1]))
        elif self.args.dims:
            dims = self.args.dims.split("x")
            self.set_default_size(int(dims[0]), int(dims[1]))
        elif self.args.power:
            self.set_default_size(self.args.isize * 8.5, self.args.isize * 3.7)
        else:
            if not geometry:
                self.set_default_size(1024, 1000)
            elif geometry.w > geometry.h:
                self.set_default_size(geometry.w * .5, geometry.h * .8)
            else:
                self.set_default_size(geometry.w * .9, geometry.h * .7)

    def mk_items_cont_box(self):
        outer_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)

        self.search_box = Gtk.SearchEntry()
        self.search_box.set_property("name", "searchbox")
        self.search_box.set_sensitive(True)
        self.search_box.connect("changed", self.on_search_change)
        outer_box.pack_start(self.search_box, False, False, 0)

        if self.args.dmenu:
            entries = []
            self.args.noic = True
            self.args.lines = True
            for line in sys.stdin:
                line = line.strip()
                if not line:
                    continue
                elif line.startswith("j:"):
                    item = Item.from_dict(json.loads(line[2:]))
                    if self.args.noic and item.icon:
                        self.args.noic = False
                        self.args.lines = False
                else:
                    item = Item(line)
                entries.append(item)
        elif self.args.jstr:
            entries = json_str_entries(self.args.jstr)
        elif self.args.jfile:
            entries = json_file_entries(self.args.jfile)
        elif self.args.power:
            entries = power_entries()
        else:
            entries = desktop_entries(self.args.update, self.args.dir) + \
                power_entries()

        self.items_cont = ItemsContainer(self.args, self, entries, self.search_box)
        outer_box.pack_start(self.items_cont.box(), True, True, 0)

        if self.args.index and self.args.index >= 0 and self.args.index < len(entries):
            self.items_cont.select_n(self.args.index)
        else:
            self.items_cont.select_n(0)

        return outer_box

    def mk_trm_box(self):
        trm = Vte.Terminal()
        pty = Vte.Pty.new_sync(Vte.PtyFlags.DEFAULT)
        trm.set_pty(pty)
        trm.set_cursor_shape(Vte.CursorShape.IBEAM) # BLOCK, IBEAM, UNDERLINE
        trm.set_cursor_blink_mode(Vte.CursorBlinkMode.OFF) # SYSTEM, ON, OFF
        trm.set_scrollback_lines(0)
        trm.set_clear_background(False)

        font = os.getenv("FONT_SIZE")
        if font:
            try:
                font = font.split(":size=")
                font_size = float(font[1])
                font = font[0]
                f = Pango.FontDescription.from_string(font)
                f.set_size(font_size * Pango.SCALE)
                trm.set_font(f)
            except:
                pass
        trm.set_font_scale(1)

        pty.spawn_async(None, ["sh", "-c", self.args.trm],
                        None, 0, None, None, -1, None, None, None)
        self.trm = trm
        return trm

    def on_search_change(self, item):
        if self.items_cont:
            self.items_cont.update()

    def on_key_release(self, item, event):
        if event.type == Gdk.EventType.KEY_RELEASE:
            key = Gdk.keyval_name(event.keyval)

            if self.search_box and \
               not self.search_box.has_focus() and \
               event.string and \
               (event.string.isalnum() or event.string in "$ "):
                #self.search_box.grab_focus()
                self.search_box.set_text(self.search_box.get_text() + event.string)
                self.search_box.set_position(-1)

            elif self.search_box and \
                 not self.search_box.has_focus() and \
                 key == "BackSpace":
                self.search_box.set_text(self.search_box.get_text()[:-1])
                self.search_box.set_position(-1)

            elif key == "Escape":
                if self.search_box and self.search_box.get_text():
                    self.search_box.set_text("")
                    self.items_cont.update()
                else:
                    Gtk.main_quit()

            elif self.search_box and key == "Return":
                text = self.search_box.get_text()
                if text.startswith("$"):
                    text = text[1:]
                    subprocess.Popen(text, shell=True)
                    Gtk.main_quit()
                elif text:
                    ret = self.items_cont.launch_first()
                    if not ret and self.args.dmenu:
                        print(text)
                        Gtk.main_quit()

        return True

    def on_focus_out(self, item, event):
        if msg is None and not self.args.stay:
            Gtk.main_quit()

class ItemsContainer:
    def __init__(self, args, win, items_list, search_box=None):
        self.args = args
        self.win = win
        self.items_list = items_list
        self.search_box = search_box
        self.first = None
        self.flow = Gtk.FlowBox()
        self.hover_count = 0 # changed below in Item

        if self.args.noic:
            max_per_line = len(self.items_list) // 10
            if max_per_line < 1:
                max_per_line = 1
        else:
            max_per_line = 100

        m = 10
        self.flow.set_margin_start(m)
        self.flow.set_margin_end(m)
        self.flow.set_max_children_per_line(max_per_line)
        self.flow.set_homogeneous(True)
        self.flow.set_orientation(Gtk.Orientation.HORIZONTAL)
        if not self.args.lines:
            self.flow.set_halign(Gtk.Align.CENTER)
        self.flow.set_filter_func(self.filter_fun)
        self.flow.connect("child_activated", self.on_activate)
        for item in items_list:
            item.parent = self
            self.flow.insert(item.box(self.args), -1)

        vbox = Gtk.VBox()
        vbox.set_spacing(15)
        vbox.pack_start(self.flow, False, False, 0)

        self.scroll = Gtk.ScrolledWindow()
        self.scroll.add(vbox)

    def box(self):
        return self.scroll

    def child2item(self, child):
        return self.items_list[child.get_index()]

    def select_n(self, n):
        child = self.flow.get_child_at_index(n)
        if child:
            child.grab_focus()
            self.flow.select_child(child)

    def update(self):
        self.first = None
        self.flow.invalidate_filter()

    def phrase(self):
        if not self.search_box:
            return ""
        else:
            return self.search_box.get_text()

    def filter_fun(self, child):
        if not self.phrase():
            app = None
            ret = True
        else:
            app = self.child2item(child)
            ret = self.phrase().lower() in app.name.lower()

        if ret and self.first is None and app is not None:
            self.first = app

        return ret

    def on_activate(self, parent, child):
        app = self.child2item(child)
        self.launch(app)

    def launch_now(self, app):
        command = app.exec
        if command:
            if app.terminal:
                command = "$TERMINAL -e " + command # TODO: make it more portable
            subprocess.Popen(command, shell=True)
        else:
            print(app.name)
        Gtk.main_quit()

    def launch(self, app):
        if app.confirm:
            self.confirm_dialog(app.name, lambda: self.launch_now(app))
        else:
            self.launch_now(app)

    def launch_first(self):
        if self.first is not None:
            self.launch(self.first)
            return True
        else:
            return False

    def confirm_dialog(self, name, on_yes):
        global msg
        msg = Gtk.MessageDialog(
            self.win,
            Gtk.DialogFlags.MODAL,
            Gtk.MessageType.QUESTION,
            Gtk.ButtonsType.YES_NO,
            name + "?"
        )
        def msg_res(msg, res):
            if res == Gtk.ResponseType.YES:
                on_yes()
            msg.destroy()
            Gtk.main_quit()
        msg.connect("response", msg_res)
        msg.show()

@dataclass
class Item:
    name:     str          = ""
    exec:     str          = ""
    icon:     str          = ""
    comment:  str          = ""
    terminal: bool         = False
    max_lbl:  int          = 15
    confirm:  bool         = False
    _box:     Gtk.Box      = None
    args                   = None
    parent:   Gtk.Box      = None

    def from_dict(json_dict):
        if type(json_dict) == str:
            return Item(json_dict)
        app = Item()
        for attr in ["name", "exec", "icon", "comment", "terminal"]:
            if attr in json_dict:
                setattr(app, attr, json_dict[attr])
        return app

    def to_dict(self):
        return {
            "name":     self.name,
            "exec":     self.exec,
            "icon":     self.icon,
            "comment":  self.comment,
            "terminal": self.terminal,
        }

    def tooltip_text(self):
        if self.comment:
            comment = self.name + ": " + self.comment
        else:
            comment = self.name
        if self.exec:
            if comment:
                comment += " "
            comment += f"({self.exec})"
        return comment

    def box(self, args):
        if self._box is not None:
            return self._box

        lbl = Gtk.Label(label=self.name)
        if not args.noic:
            img = self.app_image(self.icon, args.isize)

        as_line = args.lines or args.noic or args.power

        if as_line:
            box = Gtk.HBox(Gtk.Orientation.VERTICAL)
            lbl.set_halign(Gtk.Align.START)
            if not args.noic:
                box.pack_start(img, False, False, 0)
            box.pack_start(lbl, True, True, 0)
        else:
            box = Gtk.VBox()
            lbl.set_halign(Gtk.Align.CENTER)
            lbl.set_ellipsize(Pango.EllipsizeMode.END)
            lbl.set_max_width_chars(self.max_lbl)
            box.set_size_request(args.isize * 2, args.isize * 2)
            if not args.noic:
                box.pack_start(img, True, True, 5)
            box.pack_start(lbl, True, True, 5)

        self._box = Gtk.EventBox()
        self._box.add(box)
        self._box.connect("enter-notify-event", self.on_hover)

        return self._box

    def on_hover(self, item, event):
        if self.parent:
            self.parent.hover_count += 1
            if self.parent.hover_count == 1:
                # skip changing selecting on start
                return
            elif self.parent.hover_count >= 2:
                # skip showing tooltip on start
                self._box.set_tooltip_text(self.tooltip_text())
        flowboxchild = item.get_parent()
        flowbox = flowboxchild.get_parent()
        flowbox.select_child(flowboxchild)

    def app_image(self, icon, isize):
        icon_theme = Gtk.IconTheme.get_default()
        try:
            if icon.startswith("/"):
                pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_size(icon, isize, isize)
            else:
                if icon.endswith(".svg") or icon.endswith(".png"):
                    icon = icon.split('.')[0]
                pixbuf = icon_theme.load_icon(icon, isize,
                                              Gtk.IconLookupFlags.FORCE_SIZE)
        except:
            pixbuf = icon_theme.load_icon("application-x-executable",
                                          isize, Gtk.IconLookupFlags.FORCE_SIZE)
        return Gtk.Image.new_from_pixbuf(pixbuf)

if __name__ == "__main__":
    main()
