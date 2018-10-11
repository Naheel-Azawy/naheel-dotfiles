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

function cd..;     cd ..; end
function e;        exit 0; end
function ee;       e; end
function ث;        e; end
function ls;       command ls --color --group-directories-first $argv; end
function l;        ls $argv; end
function ll;       ls -lh $argv | more; end
function c;        clear; end
function h;        history; end
function gh;       history | grep $argv; end
function m;        tmux $argv; end
function r;        ranger $argv; end
function s;        swallow $argv; end
function mkdircd;  mkdir $argv; and cd $argv; end
function mkd;      mkdir $argv; end
function mkdc;     mkdircd $argv; end
function diff;     colordiff $argv | more; end
function wdiff;    command wdiff $argv | colordiff | more; end
function diffstr;  test (count $argv) -gt 2; and set a $argv[3..-1]; \
    diff  $a (echo -e $argv[1] | psub) (echo -e $argv[2] | psub); end
function wdiffstr; test (count $argv) -gt 2; and set a $argv[3..-1]; \
    wdiff $a (echo -e $argv[1] | psub) (echo -e $argv[2] | psub); end

