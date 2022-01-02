# TODO: move to personal

bookmark ~/Documents/events/2021_12_01_Work_Research_QU_smartgrid_security
bookmark ~/Documents/QU/3.5-TA/0-fall-2021
bookmark ~/Documents/events
bookmark ~/.dotfiles

add_fun myless 'Less a file'
bind ctrl-p fun myless
myless() {
    tput rmcup
    less "$f"
}

add_fun mystat 'File status'
mystat() {
    tput rmcup
    stat "$f" | less
}

add_fun myedit 'Edit file'
myedit() {
    tput rmcup
    edit "$f"
}

add_fun kdesend 'Send via KDE connect'
kdesend() {
    tput rmcup
    name=$(kdeconnect-cli -a 2>/dev/null |
               sed -rn 's/\- (.+):.+/\1/p' |
               menu_interface)
    kdeconnect-cli -n "$name" --share "$f"
}

add_fun lopdf 'Libreoffice to PDF'
lopdf() {
    tput rmcup
    echo "$fx" | while read -r file; do
        libreoffice --headless --convert-to pdf "$file"
    done
}

add_fun chmodmenu 'Chmod'
chmodmenu() {
    tput rmcup
    m=$({
           echo +x
           echo -x
           echo 644
           echo 755
       } | menu_interface)
    [ -n "$m" ] || return
    echo "$fx" | while read -r file; do
        chmod "$m" "$file"
    done
}

bind alt-c fun orglink
add_fun orglink 'Copy org-mode link'
orglink() {
    echo "$fx" | while read -r file; do
        bn=$(basename "$file")
        echo "[[$file][$bn]]"
    done | clipboard
}
