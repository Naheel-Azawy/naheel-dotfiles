import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, Gdk

import warnings
warnings.filterwarnings("ignore")

class EmptyWindow(Gtk.Window):
    def __init__(self):
        Gtk.Window.__init__(self)
        self.set_position(Gtk.WindowPosition.CENTER)
        self.set_default_size(400, 400)
        self.set_title("")
        self.set_wmclass("empty", "Empty") # FIXME: depricated, what else can be used?
        self.connect("delete-event", Gtk.main_quit)
        self.connect("key-press-event", self.key_press)

        self.set_app_paintable(True)
        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        if visual is None:
            print("NO ALPHA :(")
            visual = screen.get_system_visual()
        self.set_visual(visual)

    def key_press(self, item, event):
        key = Gdk.keyval_name(event.keyval)
        if key == "q" or key == "Escape":
            Gtk.main_quit()

def main(args):
    win = EmptyWindow()
    win.show_all()
    Gtk.main()
