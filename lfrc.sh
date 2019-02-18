# interpreter for shell commands (needs to be POSIX compatible)
set shell sh

# set '-eu' options for shell commands
# These options are used to have safer shell commands. Option '-e' is used to
# exit on error and option '-u' is used to give error for unset variables.
# Option '-f' disables pathname expansion which can be useful when $f, $fs, and
# $fx variables contain names with '*' or '?' characters. However, this option
# is used selectively within individual commands as it can be limiting at
# times.
set shellopts '-eu'

# set internal field separator (IFS) to "\n" for shell commands
# This is useful to automatically split file names in $fs and $fx properly
# since default file separator used in these variables (i.e. 'filesep' option)
# is newline. You need to consider the values of these options and create your
# commands accordingly.
set ifs "\n"

# leave some space at the top and the bottom of the screen
set scrolloff 10

# set the previewer script
set previewer ~/.config/lf/pv.sh

# define a custom 'open' command
# This command is called when current file is not a directory. You may want to
# use either file extensions and/or mime types here. Below uses an editor for
# text files and a file opener for the rest.
cmd open ${{
              case $(file --mime-type $f -b) in
                  text/*) $EDITOR $fx;;
                  *) for f in $fx; do $OPENER $f > /dev/null 2> /dev/null & done;;
              esac
          }}

# rename current file without overwrite
cmd rename %[ -e $1 ] && printf "file exists" || mv $f $1

# make sure trash folder exists
%mkdir -p ~/.trash

# move current file or selected files to trash folder
# (also see 'man mv' for backup/overwrite options)
cmd trash %set -f; mv $fx ~/.trash

# delete current file or selected files (prompting)
cmd delete ${{
                set -f
                printf "$fx\n"
                printf "delete? [y/n] "
                read ans
                [ $ans = "y" ] && rm -rf $fx
            }}

# show progress for file copying with paste
cmd paste &{{
               load=$(lf -remote 'load')
               mode=$(echo "$load" | sed -n '1p')
               list=$(echo "$load" | sed '1d')
               if [ $mode = 'copy' ]; then
                   rsync -av --ignore-existing --progress $list . \
                       | stdbuf -i0 -o0 -e0 tr '\r' '\n' \
                       | while read line; do
                       lf -remote "send $id echo $line"
                   done
               elif [ $mode = 'move' ]; then
                   mv -n $list .
               fi
               lf -remote 'send load'
               lf -remote 'send clear'
           }}

# create a symlink
cmd paste-symlink &{{
                       load=$(lf -remote 'load')
                       mode=$(echo "$load" | sed -n '1p')
                       list=$(echo "$load" | sed '1d')
                       if [ $mode = 'copy' ]; then
                           for f in $list; do
                               ln -s "$f" "$(pwd)/$(basename $f)"
                           done
                           lf -remote 'send load'
                           lf -remote 'send clear'
                       fi
           }}

# create a new directory
cmd mkdir ${{
               mkdir $1
           }}

# extract the current file with the right command
# (xkcd link: https://xkcd.com/1168/)
cmd extract ${{
                 set -f
                 case $f in
                     *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) tar xjvf $f;;
                     *.tar.gz|*.tgz) tar xzvf $f;;
                     *.tar.xz|*.txz) tar xJvf $f;;
                     *.zip) unzip $f;;
                     *.rar) unrar x $f;;
                     *.7z) 7z x $f;;
                 esac
             }}

# compress current file or selected files with tar and gunzip
cmd tar ${{
             set -f
             mkdir $1
             cp -r $fx $1
             tar czf $1.tar.gz $1
             rm -rf $1
         }}

# compress current file or selected files with zip
cmd zip ${{
             set -f
             mkdir $1
             cp -r $fx $1
             zip -r $1.zip $1
             rm -rf $1
         }}

# use enter for shell commands
map <enter> shell

# execute current file (must be executable)
map x $$f
map X !$f

# dedicated keys for file opener actions
map o &mimeopen $f
map O $mimeopen --ask $f

# rename file
map r push :rename<space>

# rename dir
map R $vidir .

# basic
map <c-x><c-c> quit
map <a-x>      console

# filesystem operations
map <c-y>y           paste
map <c-y>l           paste-symlink
map <c-w>            cut
map <a-w>            copy
map <delete><delete> trash
map <delete>D        delete

# up and down
map <esc><lt> top
map <esc><gt> bottom

# mini view
map <c-x>m :set nopreview; set ratios 1

# full view
map <c-x>f :set ratios 1:2:3; set preview

# search
map <c-s> search

# fuzzy search
map f $lf -remote "send $id select $(fzf)"

# dirty hack
map <up>   :up   #; &rm -f /tmp/lfimglock
map <down> :down #; &rm -f /tmp/lfimglock

# default stuff
map zh set hidden!
map zr set reverse!
map zn set info
map zs set info size
map zt set info time
map za set info size:time
map sn :set sortby natural; set info
map ss :set sortby size; set info size
map st :set sortby time; set info time
map gh cd ~
