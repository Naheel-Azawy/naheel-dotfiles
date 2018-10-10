set fish_greeting ""

function cd..;     cd ..; end
function e;        exit 0; end
function ee;       e; end
function ث;        e; end
function l;        ls -lh --color $argv | more; end
function c;        clear; end
function h;        history; end
function gh;       history | grep $argv; end
function m;        tmux $argv; end
function r;        ranger $argv; end
function mkdircd;  mkdir $argv; and cd $argv; end
function diff;     colordiff $argv | more; end
function wdiff;    /usr/bin/wdiff $argv | colordiff | more; end
function diffstr;  test (count $argv) -gt 2; and set a $argv[3..-1]; \
    diff  $a (echo -e $argv[1] | psub) (echo -e $argv[2] | psub); end
function wdiffstr; test (count $argv) -gt 2; and set a $argv[3..-1]; \
    wdiff $a (echo -e $argv[1] | psub) (echo -e $argv[2] | psub); end

