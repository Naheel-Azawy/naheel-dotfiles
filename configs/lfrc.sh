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
set previewer stpv
set cleaner stpvimgclr
&stpvimg --listen $id

# enable mouse support
set mouse on

# show icons
set icons

# COMMANDS -------------------------------------------------------------------

# define a custom 'open' command
cmd open ${{
              archive lfopen $id $f ||
                  open --lfid $id $fx
          }}

# display git repository status in your prompt (from docs)
cmd on-cd &{{
               source /usr/share/git/completion/git-prompt.sh
               GIT_PS1_SHOWDIRTYSTATE=auto
               GIT_PS1_SHOWSTASHSTATE=auto
               GIT_PS1_SHOWUNTRACKEDFILES=auto
               GIT_PS1_SHOWUPSTREAM=auto
               git=$(__git_ps1 " (%s)") || true
               dev=$(findmnt -T . -no "source,avail,size,label" |
                         awk '$4!="" {$4=$4" "}; {printf "%s%s (%s/%s)", $4, $1, $2, $3}')
               #fmt="\033[32;1m%u@%h\033[0m:\033[34;1m%w/\033[0m\033[1m%f$dev$git\033[0m"
               fmt=" \033[1m\033[34m%w\033[1m: \033[37m$dev\033[1m\033[32m$git\033[0m\033[0m"
               lf -remote "send $id set promptfmt \"$fmt\""
               archive lfoncd $id $f
           }}
on-cd

# create a new directory
cmd mkdir ${{
               s='' && [ ! -w . ] && s='sudo'
               $s mkdir -p "$@"
               lf -remote "send $id cd \"$@\""
           }}

# touch with sudo
cmd touch ${{
               s='' && [ ! -w . ] && s='sudo'
               $s touch "$@"
           }}

# delete/trash current file or selected files (prompting)
cmd delete ${{
                set -f
                printf "$fx\n"
                printf "Move files to trash? or [d]elete permanently? [Y/n/d] "
                read ans
                case "$ans" in
                    d|D)
                        s='' && [ ! -w . ] && s='sudo'
                        $s rm -rf $fx
                        lf -remote "send $id reload";;
                    n|N) ;;
                    *)
                        # move current file or selected files to trash folder
                        # using trash-cli (https://github.com/andreafrancia/trash-cli)
                        {
                            gio trash $fx || trash-put $fx
                            lf -remote "send $id reload"
                            lf -remote "send $id echo trashed"
                        } &
                        lf -remote "send $id echo moving to trash...";;
                esac
            }}

# copy with x-special clipboard
cmd copy-special &{{
                      CP=''
                      for f in $fx; do
                          CP="${CP}$f
"
                      done
                      printf "$CP" |
                          xclip -i -selection clipboard
                      lf -remote "send $id copy"
                  }}

# cut with x-special clipboard
cmd cut-special &{{
                     CP='x-special/nautilus-clipboard
cut
'
                     for f in $fx; do
                         CP="${CP}file://$f
"
                     done
                     printf "$CP" |
                         xclip -i -selection clipboard
                     lf -remote "send $id cut"
                 }}

# pasting done right
cmd paste $cp-p --lf-paste $id

# create a symlink
cmd paste-symlink ${{
                       load=$(lf -remote 'load')
                       mode=$(echo "$load" | sed -n '1p')
                       list=$(echo "$load" | sed '1d')
                       if [ $mode = 'copy' ]; then
                           s='' && [ ! -w . ] && s='sudo'
                           for f in $list; do
                               $s ln -s "$f" "$(pwd)/$(basename $f)"
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
                           s='' && [ ! -w . ] && s='sudo'
                           for f in $list; do
                               archive extract "$f"
                           done
                           lf -remote 'send load'
                           lf -remote 'send clear'
                       fi
                   }}

# create an executable shell script pointing to copied file
cmd paste-shell-executable ${{
                                load=$(lf -remote 'load')
                                mode=$(echo "$load" | sed -n '1p')
                                list=$(echo "$load" | sed '1d')
                                if [ $mode = 'copy' ]; then
                                    s='' && [ ! -w . ] && s='sudo'
                                    for f in $list; do
                                        txt="#!/bin/sh
                                        exec '$(realpath """$f""")'"
                                        out="$(basename """$f""").sh"
                                        $s echo "$txt" > "$out"
                                        $s chmod +x "$out"
                                    done
                                    lf -remote 'send load'
                                    lf -remote 'send clear'
                                fi
                            }}

# extract the current file with the right command
cmd extract $archive extract "$f"

# compress current file or selected files with tar and gunzip
cmd tar $archive tar $1 $fx

# compress current file or selected files with zip
cmd zip $archive zip $1 $fx

# rename current file without overwrite
cmd rename ${{
                if [ "$f" != "$1" ]; then
                    if [ -e "$1" ]; then
                        lf -remote "send $id echo $1 exist"
                    else
                        s='' && [ ! -w . ] && s='sudo'
                        $s mv "$f" "$1"
                    fi
                fi
            }}

cmd rename-editor ${{
                       tmp=$(mktemp)
                       f=$(basename "$f")
                       echo -n "$f" > "$tmp"
                       $EDITOR "$tmp"
                       s='' && [ ! -w . ] && s='sudo'
                       new=$(cat "$tmp")
                       if [ "$new" ] && [ "$new" != "$f" ]; then
                           $s mv "$f" "$new"
                       fi
                       rm -f "$tmp"
                   }}

# rename all files in directory
# from: https://github.com/gokcehan/lf/issues/149#issuecomment-470960434
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
                         s='' && [ ! -w . ] && s='sudo'
		                     while [ $counter -le $max ]; do
			                       a="$(cat $index | sed "${counter}q;d")"
			                       b="$(cat $index_edit | sed "${counter}q;d")"
			                       counter=$(($counter+1))
			                       [ "$a" = "$b" ] && continue
			                       [ -e "$b" ] && echo "File exists: $b" && continue
			                       $s mv "$a" "$b"
		                     done
	                   else
		                     echo "Number of lines must stay the same"
	                   fi
	                   rm $index $index_edit
                 }}

# rename pdf files based of pdfinfo title
cmd pdf-auto-rename &{{
                         for f in $fx; do
                             TITLE=$(pdfinfo "$f" | sed -En 's/Title:\s+(.+)s/\1/p')
                             if [ "$TITLE" ]; then
                                 D=$(dirname "$f")
                                 N=$(basename "$f")
                                 mv "$f" "$D/${TITLE}_$N"
                                 lf -remote "send $id echo Found title ${TITLE}"
                             else
                                 lf -remote "send $id echo No title found"
                             fi
                         done
                     }}

# dynamically set number of columns
cmd autoratios &{{
                    w=$(tput cols)
                    if [ $w -le 60 ]; then
                        lf -remote "send $id set nopreview"
                        lf -remote "send $id set ratios 1"
                        stpvimgclr
                    elif [ $w -le 130 ]; then
                        lf -remote "send $id set ratios 1:2"
                        lf -remote "send $id set preview"
                    else
                        lf -remote "send $id set ratios 1:5:6"
                        lf -remote "send $id set preview"
                    fi
                }}
autoratios # auto-run at start

# force tiny ratios
cmd tinyratios &{{
                    lf -remote "send $id set nopreview"
                    lf -remote "send $id set ratios 1"
                    stpvimgclr
                }}

# fuzzy search jump
cmd fzf ${{
             F="$(ls | fzfp)"
             [ -f "$F" ] && \
                 lf -remote "send $id select \"$F\"" || \
                     lf -remote "send $id cd \"$F\""
         }}

# select which program to open the current file with
cmd open-with &open --lfid $id --ask $f

# set the default program for the current file
cmd open-with-default &open --lfid $id --ask-default $f

# chmod
cmd chmod ${{
               echo Enter new mode for
               echo $fx
               printf 'mod: '
               read -r m
               chmod "$m" $fx
               lf -remote "send $id unselect"
               lf -remote "send $id reload"
           }}

# chmod +x
cmd chmod+x &{{
                 chmod +x $fx
                 lf -remote "send $id unselect"
                 lf -remote "send $id reload"
             }}

# chmod -x
cmd chmod-x &{{
                 chmod -x $fx
                 lf -remote "send $id unselect"
                 lf -remote "send $id reload"
             }}

# cd to a partition
cmd go_usb ${{
                d=$(lsblk -rpo "name,type,fsavail,fssize,mountpoint,label" |
                        awk '$6!=""{$6=$6" "};($2=="part"||$2=="lvm")&&$5!=""{printf "%s#%s#%s#(%s/%s)\n", $5, $1, $6, $3, $4}' |
                        tac | column -t -s'#' |
                        fzfp --nopv | cut -d ' ' -f1)
                [ "$d" ] && lf -remote "send $id cd '$d'"
            }}

# send with wifi
cmd send $qr-filetransfer $f

# receive from wifi
cmd receive $qr-filetransfer -receive .

# plot signals
cmd plot &plot $f

# plot signals fft
cmd plotfft &plot -f $f

# MAPPINGS -------------------------------------------------------------------

# use enter to open
map <enter> open

# back
map <bs2> updir
map D     updir

# emacs
map x push :$edit<space>

# open a full shell
map <c-s> $$SHELL

# dedicated keys for file opener actions
map o open-with
map O open-with-default

# rename file
map r     rename-editor
map <f-2> rename-editor

# rename dir
map R $vidir

# basic
map <c-q> quit
map <a-x> push :
map <c-a> invert
map <c-g> :unselect; clear
map <f-5> reload

# filesystem operations
map <delete> delete
map <c-c>    copy-special
map <c-x>    cut-special
map <c-v>    paste
map <a-v>l   paste-symlink
map <a-v>e   paste-extract
map <a-v>s   paste-shell-executable
map c        chmod

# up and down
map <esc><lt> top
map <esc><gt> bottom
map <c-e>     bottom # fix 'end'

# ratios
map a autoratios
map t tinyratios

# fuzzy search
map f     $lf -remote "send $id select \"$(ls | fzfp)\""
map <c-f> $lf -remote "send $id select \"$(fzfp)\""

# image viewing
map <c-p> &sxivv --lf $id $f -t

# preview
map p $stpv "$f" | less -R
map l $less "$f"

# drag in/out
map d &dragon $fx
#map di &dragon -t

# Nautilus...
map n &nautilus .

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

# mouse
map <m-1> open   # primary
map <m-2> updir  # secondary
# map <m-3> down   # middle
# map <m-4> down
# map <m-5> down
# map <m-6> down
# map <m-7> down
# map <m-8> down
map <m-up>    up
map <m-down>  down
# map <m-left>  down
# map <m-right> down

# bookmarks
map gh cd ~
map gd :cd ~/Downloads; set sortby time; set info time; set reverse
map gc cd ~/Documents
map ge cd ~/Documents/events
map gp cd ~/Pictures
map gm cd ~/Music
map gv cd ~/Videos
map gj cd ~/Projects
map gu go_usb
map go $lf -remote "send $id cd \"$DOTFILES_DIR\""

# TODO: move to personal
map gQ $lf -remote "send $id cd \"$QU\""
map gq $lf -remote "send $id cd \"$QU/2-Masters/4-spring-2021\""
