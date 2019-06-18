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

function open --description "Open file in default application"
    for i in $argv
        if test -d $i
            cd $i
        else
            command open $i
        end
    end
end

function lf
    set tmp (mktemp)
    set fid (mktemp)
    command lf -command '$printf $id > '"$fid"'' -last-dir-path=$tmp $argv
    set id (cat $fid)
    set archivemount_dir "/tmp/__lf_archivemount_$id"
    if test -f "$archivemount_dir"
        for line in (cat "$archivemount_dir")
            sudo umount "$line"
            rmdir "$line"
        end
        rm -f "$archivemount_dir"
    end
    rm $fid
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

function lf-keep-dir
    command lf $argv
end

function ls
    command ls --color --group-directories-first $argv
end
function mkdircd
    mkdir -p $argv; and cd $argv[-1]
end
function cpprog
    rsync -ah --progress $argv
end

function diff
    colordiff $argv | more
end
function wdiff
    command wdiff $argv | colordiff | more
end
function diffstr
    test (count $argv) -gt 2; and set a $argv[3..-1]
    diff  $a (echo -e $argv[1] | psub) (echo -e $argv[2] | psub)
end
function wdiffstr
    test (count $argv) -gt 2; and set a $argv[3..-1]
    wdiff $a (echo -e $argv[1] | psub) (echo -e $argv[2] | psub)
end

function d
    set sp (string split '.' $argv[-1])
    test $sp[-1] != 'pdf'; and set r libreoffice; or set r $READER
    echo $r
    swallow $r $argv
end

function ث
    lang-toggle >/dev/null; exit $argv
end
function مس
    lang-toggle >/dev/null; ls $argv
end

abbr e     'exit'
abbr ee    'exit'
abbr E     'exit'
abbr q     'exit'
abbr c     'clear'
abbr l     'ls'
abbr ll    'ls -lh'
abbr la    'ls -lha'
abbr cd..  'cd ..'
abbr mkd   'mkdir -p'
abbr mkdc  'mkdircd'
abbr h     'history'
abbr gh    'history | grep'
abbr g     'grep'
abbr gr    'grep -r'

abbr t     'true'
abbr nil   'false'
abbr fn    'function'
abbr fun   'function'

abbr stime 'date "+%s"'    # time in seconds
abbr mtime 'date "+%s%3N"' # time in milliseconds
abbr ntime 'date "+%s%N"'  # time in nanoseconds

abbr x     'emacs-in'
abbr xg    'emacs-gui'
abbr xd    'emacs-daemon'
abbr xk    'emacs-daemon-kill'
abbr xsh   'new-shell-script'

abbr gita  'git add -A'
abbr gitc  'git commit -m'
abbr gitp  'git push origin master'
abbr gits  'git status'
abbr gitd  'git diff'
abbr gitl  'git log'
abbr gito  'git checkout'
abbr gitq  'git add -A && git commit -m "quick update" && git push origin master'
abbr gitn  'git add -A && git commit -m "couple of things" && git push origin master'

abbr o     'open'
abbr m     'tmux'
abbr f     'lf'
abbr r     'ranger'
abbr n     'nnn'
abbr s     'swallow'
abbr cb    'clipboard'
abbr py    'python3'
abbr ly    'lyrics'
abbr trn   'trans'
abbr trna  'trans :ar'
abbr trnp  'trans -b --play'
abbr ddd   'sudo dd status=progress bs=2048 if=... of=...'
abbr cath  'highlight --replace-tabs=4 --out-format=xterm256 --force'
abbr pc    'sudo pacman -S'
abbr cm    'cmatrix'
abbr chx   'chmod +x'
