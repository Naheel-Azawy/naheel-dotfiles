# TODO: move to personal

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
