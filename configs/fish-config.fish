function fish_greeting
    set -l user
    set -l sshc
    switch "$USER"
        case root toor
            # show user if root
            set user $USER
        case '*'
            # show user only if multiple users on the machine
            if test (command ls -1 /home/ | grep -qv lost+found | wc -l) -gt 1
                set user $USER
            end
    end
    # show hostname only if sshed
    if test "$SSH_CONNECTION" != ''
        set sshc (string split ' ' $SSH_CONNECTION)
    end
    if [ "$user" != '' ] || [ "$sshc" != '' ]
        echo -n 'New session for '
        echo -s -n $USER @ (prompt_hostname)
        printf ' (SSH from %s:%s to %s:%s)' $sshc[1] $sshc[2] $sshc[3] $sshc[4]
        echo
    end
    # show pwd if not at home
    if test $PWD != $HOME
        echo cd $PWD
    end
end

function fish_prompt --description 'Write out the prompt'
	  set -l color_cwd
    set -l suffix
    set -l face
    set -l cwd
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
    # get sad if failed :(
    if test $status != 0
        set face (set_color brred)' :( '(set_color normal)
    end
    # only current directory
    set cwd (string replace -r '^'"$HOME"'($|/)' '~$1' $PWD | string split '/')[-1]
    test "$cwd" = '' && set cwd /
    echo -n -s -e $face $host (set_color $color_cwd) $cwd (set_color normal) "$suffix "
end

function open --description "Open file in default application"
    command open $argv
    set -l opendirfile '/tmp/__opendir'
    if test -f $opendirfile
        set -l opendir (cat $opendirfile)
        if test -d $opendir
            cd $opendir
        end
        rm -f $opendirfile
    end
end

function lf
    set fwd (mktemp) # last working directory temp file
    set fid (mktemp) # lf id temp file
    command lf -command '$printf $id > '"$fid"'; stpvimg --listen $id &' -last-dir-path=$fwd $argv
    set id (cat $fid)
    # end the image preview listener
    stpvimg --end $id
    # archivemount integration
    set archivemount_dir "/tmp/__lf_archivemount_$id"
    if test -f "$archivemount_dir"
        for line in (cat "$archivemount_dir")
            sudo umount "$line"
            rmdir "$line"
        end
        rm -f "$archivemount_dir"
    end
    # cd on exit
    if test -f "$fwd"
        set dir (cat $fwd)
        rm -f $fwd
        if test -d "$dir"
            if test "$dir" != (pwd)
                echo cd $dir
                cd $dir
            end
        end
    end
    rm $fid
end

function ls
    command ls --color --group-directories-first $argv
end
function mkdircd
    mkdir -p $argv; and cd $argv[-1]
end

function diff
    colordiff -u $argv | less -RF
end
function wdiff
    command wdiff $argv | colordiff | less -RF
end
function diffstr
    test (count $argv) -gt 2; and set a $argv[3..-1]
    diff -u $a (echo -e $argv[1] | psub) (echo -e $argv[2] | psub)
end
function wdiffstr
    test (count $argv) -gt 2; and set a $argv[3..-1]
    wdiff $a (echo -e $argv[1] | psub) (echo -e $argv[2] | psub)
end

function arduino-cli
    command arduino-cli --config-file="$DOTFILES_DIR/configs/arduino-cli.yaml" $argv
end

function plot
    command plot $argv & disown
end

abbr ث  'lang-set us >/dev/null; exit'
abbr مس 'lang-set us >/dev/null; ls'
abbr م  'lang-set us >/dev/null; ls'
abbr ؤي 'lang-set us >/dev/null; cd'
abbr ب  'lang-set us >/dev/null; lf'

alias please=sudo

abbr bahs  'bash'
abbr e     'exit'
abbr ee    'exit'
abbr E     'exit'
abbr q     'exit'
abbr qq    'exit'
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
abbr s     'please'
abbr cb    'clipboard'
abbr py    'python3'
abbr ly    'lyrics'
abbr trn   'trans'
abbr trna  'trans :ar'
abbr trnp  'trans -b --play'
abbr ddd   'please dd status=progress bs=2048 if=... of=...'
abbr cath  'highlight --replace-tabs=4 --out-format=xterm256 --force'
abbr pc    'please pacman -S'
abbr pcs   'pacman -Ss'
abbr pcu   'please pacman -Syu'
abbr cm    'cmatrix'
abbr chx   'chmod +x'
abbr ch-x  'chmod -x'
abbr a     'arduino-cli'
abbr do    'cd $DOTFILES_DIR && open'
abbr https 'python3 -m http.server'
abbr spwd  'set prevpwd $PWD'
abbr pwdb  'cd $prevpwd'
abbr zkill 'kill -9 (ps -ef | fzfp --nopv | awk \'{print $2}\')'
abbr jql   'jq -C . | less -R'
abbr dsync 'rsync -rtu --delete --info=del,name,stats2'
abbr run   'execute'
abbr cl    'calc'
