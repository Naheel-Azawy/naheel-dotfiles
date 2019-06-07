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
set previewer lfpv

# COMMANDS ------------------------------------------------------------------------

# define a custom 'open' command
# This command is called when current file is not a directory. You may want to
# use either file extensions and/or mime types here. Below uses an editor for
# text files and a file opener for the rest.
cmd open ${{
              # file name
              case "$f" in
                  *.html)
                      browser $fx;;
                  *.tar.bz|*.tar.bz2|*.tbz|*.tbz2|*.tar.gz|*.tgz|*.tar.xz|*.txz|*.zip|*.rar|*.iso)
                      mntdir="$f-archivemount"
                      [ ! -d "$mntdir" ] && {
                          mkdir "$mntdir"
                          archivemount "$f" "$mntdir"
                          echo "$mntdir" >> "/tmp/__lf_archivemount_$id"
                      }
                      lf -remote "send $id cd \"$mntdir\""
                      lf -remote "send $id reload"
                      ;;
                  *)
                      # mime type
                      case $(file --mime-type $(realpath "$f") -b) in
                          text/*|*/json|*empty)
                              $EDITOR $fx;;
                          image/*)
                              sxivv $fx > /dev/null 2> /dev/null &;;
                          video/*)
                              mpv $fx --loop=inf > /dev/null 2> /dev/null &;;
                          *)
                              for f in $fx; do
                                  $OPENER $f > /dev/null 2> /dev/null &
                              done;;
                      esac
              esac
          }}

cmd umountarchive ${{
                       cat "/tmp/__lf_archivemount_$id" | \
                           while read -r line; do
                               sudo umount "$line"
                               rmdir "$line"
                           done
                       rm -f "/tmp/__lf_archivemount_$id"
                   }}

# rename current file without overwrite
cmd rename %[ -e $1 ] && printf "file exists" || mv $f $1

# move current file or selected files to trash folder
# using trash-cli (https://github.com/andreafrancia/trash-cli)
cmd trash %trash-put $fx

# create a new directory
cmd mkdir %mkdir -p "$@"

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

# extract the copied files in the current directory
cmd paste-extract ${{
                       load=$(lf -remote 'load')
                       mode=$(echo "$load" | sed -n '1p')
                       list=$(echo "$load" | sed '1d')
                       if [ $mode = 'copy' ]; then
                           for f in $list; do
                               case $f in
                                   *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) tar xjvf $f;;
                                   *.tar.gz|*.tgz) tar xzvf $f;;
                                   *.tar.xz|*.txz) tar xJvf $f;;
                                   *.zip) unzip $f;;
                                   *.rar) unrar x $f;;
                                   *.7z) 7z x $f;;
                               esac
                           done
                           lf -remote 'send load'
                           lf -remote 'send clear'
                       fi
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

# dynamically set number of columns
cmd autoratios &{{
                    w=$(tput cols)
                    if [ $w -le 60 ]; then
                        lf -remote "send $id set nopreview"
                        lf -remote "send $id set ratios 1"
                    elif [ $w -le 95 ]; then
                        lf -remote "send $id set ratios 1:2"
                        lf -remote "send $id set preview"
                    elif [ $w -le 160 ]; then
                        lf -remote "send $id set ratios 1:5:6"
                        lf -remote "send $id set preview"
                    else
                        lf -remote "send $id set ratios 1:2:3:5"
                        lf -remote "send $id set preview"
                    fi
                }}
autoratios # auto-run at start

# force tiny ratios
cmd tinyratios &{{
                    lf -remote "send $id set nopreview"
                    lf -remote "send $id set ratios 1"
                }}

# fuzzy search jump
cmd fzf ${{
             F="$(ls | fzf)"
             [ -f "$F" ] && \
                 lf -remote "send $id select \"$F\"" || \
                     lf -remote "send $id cd \"$F\""
         }}

# rename all files in directory
cmd bulk-rename ${{
	                   index=$(mktemp /tmp/lf-bulk-rename-index.XXXXXXXXXX)
	                   if [ -n "${fs}" ]; then
		                     echo "$fs" > $index
	                   else
		                     echo "$(ls "$(dirname $f)" | tr ' ' "\n")" > $index
	                   fi
	                   index_edit=$(mktemp /tmp/lf-bulk-rename.XXXXXXXXXX)
	                   cat $index > $index_edit
	                   $EDITOR $index_edit
	                   if [ $(cat $index | wc -l) -eq $(cat $index_edit | wc -l) ]; then
		                     max=$(($(cat $index | wc -l)+1))
		                     counter=1
		                     while [ $counter -le $max ]; do
			                       a="$(cat $index | sed "${counter}q;d")"
			                       b="$(cat $index_edit | sed "${counter}q;d")"
			                       counter=$(($counter+1))
			                       [ "$a" = "$b" ] && continue
			                       [ -e "$b" ] && echo "File exists: $b" && continue
			                       mv "$a" "$b"
		                     done
	                   else
		                     echo "Number of lines must stay the same"
	                   fi
	                   rm $index $index_edit
                 }}

# select which program to open the current file with
cmd open-with $mimeopen --ask $f

# set the default program for the current file
cmd open-with-default $mimeopen -d $f

# MAPPINGS ------------------------------------------------------------------------

# use enter for shell commands
map <enter> shell

# emacs
map x push :$emacs-in<space>

# dedicated keys for file opener actions
map o open-with
map O open-with-default

# rename file
map r push :rename<space>

# rename dir
map R $vidir .

# basic
map <c-x><c-c> quit
map <a-x>      push :
map <c-x>h     invert
map <c-g>      clear
map <f-5>      reload

# filesystem operations
map <c-y>y           paste
map <c-y>l           paste-symlink
map <c-y>e           paste-extract
map <c-w>            cut
map <a-w>            copy
map <delete><delete> trash
map <delete>D        delete

# up and down
map <esc><lt> top
map <esc><gt> bottom

# ratios
map a autoratios
map t tinyratios

# fuzzy search
map <c-s> fzf
map f     fzf
map <c-f> $lf -remote "send $id select \"$(fzf)\""

# image viewing
map <c-v> &sxivv

#full screen preview
map p $lfpv "$f" | less -R

# default stuff with spice
map zh set hidden!
map zr set reverse!
map zn set info
map zs set info size
map zt set info time
map za set info size:time
map sN :set sortby natural; set info
map ss :set sortby size; set info size
map sT :set sortby time; set info time
map sn :set sortby natural; set info; set noreverse
map st :set sortby time; set info time; set reverse

# bookmarks
map gh cd ~
map gd :cd ~/Downloads; set sortby time; set info time; set reverse
map gc cd ~/Documents
map gp cd ~/Pictures
map gm cd ~/Music
map gv cd ~/Videos
map gj cd ~/Projects
map gg cd ~/MEGA/orgmode
map go $lf -remote "send $id cd \"$DOTFILES_DIR\""
map gq $lf -remote "send $id cd \"$QU\""
map gs $lf -remote "send $id cd \"$QU/Senior/mnmspider/senior2\""
map gb cd ~/GoodStuff/vbox-shared/

#cmd imgpv ${{
#               lfimgpv --add $id $f
#     }}
#
#map <c-v> imgpv
# start the image previewer listener
# &{{
#      lfimgpv --end 0
#      lfimgpv --listen 0
#  }}
# map <up>    :up;    &lfimgpv --clear 0
# map <down>  :down;  &lfimgpv --clear 0
# map <left>  :updir; &lfimgpv --clear 0

