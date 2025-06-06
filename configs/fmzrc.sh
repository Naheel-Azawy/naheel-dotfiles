# TODO: move to personal

bookmark ~/.data
bookmark ~/"VM Shared"
bookmark ~/Documents/events/2021_12_01_University_TAMU
bookmark ~/Documents/events/2021_12_01_Work_Research_QU_smartgrid_security
bookmark ~/Documents/QU
bookmark ~/Documents/events
bookmark ~/Documents/datasheets
bookmark ~/Documents/cheatsheets
bookmark ~/Documents/papers
bookmark ~/Documents/good_books
bookmark ~/.dotfiles

bind ctrl-p 'toggle-preview' 'Toggle preview'

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

add_fun impdf 'Imagemagic to PDF'
impdf() {
    tput rmcup
    echo "$fx" | while read -r file; do
        convert "$file" "$file.pdf"
    done
}

add_fun pdfcropfun 'PDF crop'
pdfcropfun() {
    tput rmcup
    echo "$fx" | while read -r file; do
        pdfcrop "$file" &&
            crop=$(echo "$file" | sed 's/.pdf/-crop.pdf/') &&
            mv "$crop" "$file"
    done
}

bind alt-c fun orglink
add_fun orglink 'Copy org-mode link'
orglink() {
    echo "$fx" | while read -r file; do
        bn=$(basename "$file")
        echo "[[$file][$bn]]"
    done | head -c -1 | clipboard
}

add_fun wallpaper 'Set as wallpaper'
wallpaper() {
    feh --bg-fill "$f"
}

add_fun paste_backup 'Paste backup with rsync'
paste_backup() {
    [ -f "$OP_FILE" ] || return
    load=$(cat "$OP_FILE")
    mode=$(echo "$load" | sed -n '1p')
    list=$(echo "$load" | sed '1d')

    if [ "$mode" = copy ]; then
        tput rmcup
        echo "$list" | while read -r file; do
            [ -d "$file" ] || {
                echo "ERROR: '$file' is not a directory"
                break
            }
            n=$(basename "$file")
            mkdir ./"$n"
            rsync -avx --delete \
                  --info=progress2,del,name,stats2 \
                  "$file/" ./"$n"
        done
        rm -f "$OP_FILE"
    fi
}

add_fun adb_install 'ADB install'
adb_install() {
    tput rmcup
    echo "$fx" | while read -r file; do
        adb install "$file"
    done
}

add_fun cd_realpath 'cd realpath'
cd_realpath() {
    cd "$(realpath .)" || :
}

bind alt-n fun newfilelike
add_fun newfilelike 'New file with similar name'
newfilelike() {
    like=$(basename "$f")
    name=$(echo | menu_interface --prompt 'New file name> ' -q "$like")
    if [ -e "$name" ]; then
        echo "$name already exists"
    elif [ "$name" ]; then
        touch "$name"
        preselector_set_selected "$name"
    fi
}

add_fun show_exif 'List EXIF information'
show_exif() {
    tput rmcup
    exiftool "$f" | less
}

bind ctrl-r "$cmd_refresh" 'Refresh'
