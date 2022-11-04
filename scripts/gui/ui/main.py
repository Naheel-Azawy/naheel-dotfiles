import argparse

from bar   import main as bar
from menu  import main as menu
from empty import main as empty

def main():
    parser = argparse.ArgumentParser(prog="ndg", description="desktop ui elements")
    subparsers = parser.add_subparsers()

    p_menu = subparsers.add_parser("menu", help="menus and applications launcher UI")
    p_menu.set_defaults(func=menu)
    p_menu.add_argument(      "--dir",         type=str, default="",     help="directory of .desktop files")
    p_menu.add_argument("-f", "--fullscreen",  action="store_true",      help="fullscreen window")
    p_menu.add_argument("-u", "--update",      action="store_true",      help="update cache")
    p_menu.add_argument(      "--isize",       type=int,   default=72,   help="icons' size (default 72)")
    p_menu.add_argument(      "--css",         type=str,   default=None, help="style sheet")
    p_menu.add_argument(      "--power",       action="store_true",      help="show power menu")
    p_menu.add_argument(      "--stay",        action="store_true",      help="stay even when out of focus")
    p_menu.add_argument(      "--lines",       action="store_true",      help="view as lines")
    p_menu.add_argument(      "--noic",        action="store_true",      help="no icons")
    p_menu.add_argument(      "--jfile",       type=str,   default=None, help="json file as input")
    p_menu.add_argument(      "--jstr",        type=str,   default=None, help="json string as input")
    p_menu.add_argument(      "--dims",        type=str,   default=None, help="window dimensions (WxH); in chars for -trm, pixels otherwise")
    p_menu.add_argument("-d", "--dmenu",       action="store_true",      help="function in a dmenu-like way")
    p_menu.add_argument("-p", "--prompt",      type=str,   default=None, help="text prompt at the top of the window")
    p_menu.add_argument(      "--long",        action="store_true",      help="allow long lines")
    p_menu.add_argument("-n", "--index",       type=int,   default=-1,   help="pre-selected item index")
    p_menu.add_argument(      "--trm",         type=str,   default=None, help="show a mini terminal")

    p_bar = subparsers.add_parser("bar", help="top bar UI")
    p_bar.set_defaults(func=bar)
    p_bar.add_argument("-k", "--kill",       action="store_true",      help="kill bar process")
    p_bar.add_argument("-u", "--update",     type=str, default=None,   help="update a bar item")
    p_bar.add_argument("-a", "--ascii",      action="store_true",      help="output ascii only")
    p_bar.add_argument("-p", "--persistent", action="store_true",      help="keep running in a loop")
    p_bar.add_argument("items",              type=str, nargs="*",      help="items to be printed")

    p_empty = subparsers.add_parser("empty", help="empty window")
    p_empty.set_defaults(func=empty)

    args = parser.parse_args()

    if hasattr(args, "func"):
        return args.func(args)
    else:
        parser.parse_args(["--help"])
        return 1

if __name__ == "__main__":
    exit(main())
