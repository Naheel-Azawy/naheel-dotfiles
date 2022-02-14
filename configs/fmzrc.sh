# TODO: move to personal

bookmark ~/Documents/events/2021_12_01_Work_Research_QU_smartgrid_security
bookmark ~/Documents/QU/3.5-TA/1-spring-2022
bookmark ~/Documents/events
bookmark ~/.dotfiles

# add_fun myless 'Less a file'
# bind ctrl-p fun myless
# myless() {
#     tput rmcup
#     less "$f"
# }

add_fun du_file 'Disk usage'
bind alt-d fun du_file
du_file() {
    tput rmcup
    du -sh "$f"
    read -r _
}

bind ctrl-p 'toggle-preview' 'Toggle preview'

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

QRCP_PORT=35697

add_fun qrcp_send 'Send via QRCP'
qrcp_send() {
    tput rmcup
    qrcp -p "$QRCP_PORT" send "$f"
}

add_fun qrcp_receive 'Receive via QRCP'
qrcp_receive() {
    tput rmcup
    qrcp -p "$QRCP_PORT" receive
}

add_fun pdf_info 'PDF info'
pdf_info() {
    tput rmcup
    echo "$fx" | while read -r file; do
        ls -lh "$file"
        pdfinfo "$file"
        echo 'Fonts:'
        pdffonts "$file"
        echo
    done | less
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

add_fun wallpaper 'Set as wallpaper'
wallpaper() {
    feh --bg-fill "$f"
}
