#!/usr/bin/env rn
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>

int main(int argc, char *argv[])
{
  unsigned long value;
  char *terminatedAt;
  XClassHint class;
  Status status;
  Display *display;
  Window window;

  if ( argc != 3 ) {
    printf( "Usage: %s <window id> <window class>\n", argv[0] );
    return 1;
  }
  window = strtoul( argv[1], &terminatedAt, 0 );
  if ( *terminatedAt != '\0' ) {
    printf( "Could not parse window id: %s\n", argv[1] );
    return 2;
  }

  display = XOpenDisplay( NULL );
  status = XGetClassHint( display, window, &class );
  if ( !status ) return 4;

  XFree( class.res_class );
  class.res_class = strdup( argv[2] );
  printf("Setting WM_CLASS of window %lu to \"%s\", \"%s\"\n", window, class.res_name, class.res_class );
  XSetClassHint( display, window, &class );

  XCloseDisplay( display );
  XFree( class.res_name );
  XFree( class.res_class );
  return 0;
}
