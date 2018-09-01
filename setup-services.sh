#!/bin/bash
function lock-before-suspend {
    U="$1"
    P="$2"
    O='/etc/systemd/system/i3lockscreen.service'
    echo "[Unit]
Description=Lock screen before suspend
Before=sleep.target

[Service]
User=$U
Type=forking
Environment=DISPLAY=:0
ExecStart=$P

[Install]
WantedBy=suspend.target
" > "$O"
    systemctl enable i3lockscreen.service
}

function printer {
    systemctl enable org.cups.cupsd
}

lock-before-suspend "$1" "$2"
printer
