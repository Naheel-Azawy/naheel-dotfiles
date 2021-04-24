abbr() {
    alias "$1"="$2"
    ble-sabbrev "$1"="$2"
}

abbr ث  'lang us; exit'
abbr مس 'lang us; ls'
abbr م  'lang us; ls'
abbr ؤي 'lang us; cd'
abbr ب  'lang us; fmz'

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
abbr g     'grep'
abbr gr    'grep -r'

abbr stime 'date "+%s"'    # time in seconds
abbr mtime 'date "+%s%3N"' # time in milliseconds
abbr ntime 'date "+%s%N"'  # time in nanoseconds

abbr ed    'edit'
abbr nsh   'new-shell-script'

abbr gita  'git add -A'
abbr gitc  'git commit -m'
abbr gitp  'git push origin master'
abbr gits  'git status'
abbr gitd  'git diff'
abbr gitl  'git log'
abbr gito  'git checkout'
abbr gitq  'git add -A && git commit -m "quick update" && git push origin master'
abbr gitn  'git add -A && git commit -m "couple of things" && git push origin master'

abbr nd    'ndots'
abbr o     'open'
abbr m     'tmux'
abbr f     'fmz'
abbr s     'please'
abbr cb    'clipboard'
abbr py    'python3'
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
abbr ard   'arduino-cli'
abbr d     'docker'
abbr https 'python3 -m http.server'
abbr spwd  'set prevpwd $PWD'
abbr pwdb  'cd $prevpwd'
# abbr zkill 'kill -9 (ps -ef | fzfp --nopv | awk \'{print $2}\')'
abbr jql   'jq -C . | less -R'
abbr dsync 'rsync -rtu --delete --info=del,name,stats2'
abbr cl    'calc'
# abbr awkp  'awk \'{print $1}\''
abbr p     'theprayer'

abbr ytdl  'youtube-dl --add-metadata -ic'
abbr ytdla 'youtube-dl --add-metadata -xic --audio-format mp3'

ble-bind -f 'C-q' exit

ble-color-setface command_builtin fg=green,bold
