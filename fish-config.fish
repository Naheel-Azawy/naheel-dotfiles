set fish_greeting ""

function fish_prompt --description 'Write out the prompt'
	  set -l color_cwd
    set -l suffix
    switch "$USER"
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix '#'
        case '*'
            set color_cwd $fish_color_cwd
            set suffix '>'
    end
    set -l face (test $status != 0; and echo -n (set_color brred) ':(' (set_color normal))
    echo -n -s "$face$USER" @ (prompt_hostname) ' ' (set_color $color_cwd) (prompt_pwd) (set_color normal) "$suffix "
end

function cd..;     cd .. $argv; end
function e;        exit $argv; end
function ee;       e $argv; end
function E;        e $argv; end
function ث;        e $argv; end
function q;        exit $argv; end
function ls;       command ls --color --group-directories-first $argv; end
function مس;       lang-toggle >/dev/null; ls $argv; end
function l;        ls $argv; end
function ll;       ls -lh $argv | more; end
function c;        clear; end
function h;        history; end
function gh;       history | grep $argv; end
function m;        tmux $argv; end
function r;        ranger $argv; end
function n;        nnn $argv; end
function s;        swallow $argv; end
function t;        true  $argv; end
function f;        false $argv; end
function mkdircd;  mkdir -p $argv; and cd $argv[-1]; end
function mkd;      mkdir -p $argv; end
function mkdc;     mkdircd $argv; end
function cpprog;   rsync -ah --progress $argv; end
function stime;    date '+%s'    $argv; end # time in seconds
function mtime;    date '+%s%3N' $argv; end # time in milliseconds
function ntime;    date '+%s%N'  $argv; end # time in nanoseconds
function diff;     colordiff $argv | more; end
function wdiff;    command wdiff $argv | colordiff | more; end
function diffstr;  test (count $argv) -gt 2; and set a $argv[3..-1]
    diff  $a (echo -e $argv[1] | psub) (echo -e $argv[2] | psub); end
function wdiffstr; test (count $argv) -gt 2; and set a $argv[3..-1]
    wdiff $a (echo -e $argv[1] | psub) (echo -e $argv[2] | psub); end
function d;        set sp (string split '.' $argv[-1])
    test $sp[-1] != 'pdf'; and set r libreoffice; or set r $READER
    echo $r
    swallow $r $argv; end
function lfcd
    set tmp (mktemp)
    lf -last-dir-path=$tmp $argv
    if test -f "$tmp"
        set dir (cat $tmp)
        rm -f $tmp
        if test -d "$dir"
            if test "$dir" != (pwd)
                cd $dir
            end
        end
    end
end
