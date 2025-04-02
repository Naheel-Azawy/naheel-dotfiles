
focused_desktop=

pre() {
    focused_desktop=$(bspc query -D -d .focused --names)
}

post() {
    run_if_exists ndg wallpaper reset
    run_if_exists ndg bar &
    rearrange_desktops
    run_if_exists thinkpadutils x1_touch_screen_fix
    run_if_exists ndg input init
}

rearrange_desktops() {
    xr=$(xrandr)
    mons=$(echo "$xr" |
               sed -rn 's/(.+) connected(.*) ([0-9]+)x([0-9]+)\+([0-9]+)\+([0-9]+).+/\5 \1\2/p' |
               sort -n | cut -d ' ' -f2- | nl)
    mons_count=$(echo "$mons" | wc -l)

    primary_num=$(echo "$mons" | sed -rn 's/ *([0-9]+) *(.+) primary/\1/p')
    mons_before_primary=$((primary_num - 1))
    mons_after_primary=$((mons_count - primary_num))

    desktops=$(bspc query -D -d .occupied --names)
    prim_desktops=$(echo "$desktops"                          |
                        tail -n +$((mons_before_primary + 1)) |
                        head -n -$mons_after_primary)
    prim_desktops_count=$(echo "$prim_desktops" | wc -l)

    desk2mon() { run bspc desktop "$1" -m "$2"; }

    echo "$mons" | while read -r n mon isprim; do
        if [ -n "$isprim" ]; then
            # primary monitor take all other desktops
            echo "$prim_desktops" | while read -r d; do
                desk2mon "$d" "$mon"
            done
        else
            if [ "$n" -lt "$primary_num" ]; then
                # each monitor before primary take one desktop in order
                d=$(echo "$desktops" | sed "${n}q;d")
                desk2mon "$d" "$mon"
            else
                # monitors after primary take the remaining desktops
                order=$((n - primary_num)) # order after primary
                d=$((mons_before_primary + prim_desktops_count + order))
                desk2mon "$d" "$mon"
            fi
        fi
    done

    if [ -n "$focused_desktop" ]; then
        run bspc desktop -f "$focused_desktop"
    fi
}

cfg_saved="$DOTFILES_DIR/configs/automonrc-saved.sh"
[ -e "$cfg_saved" ] && . "$cfg_saved"
