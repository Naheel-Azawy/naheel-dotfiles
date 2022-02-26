
post() {
    run_if_exists ndots-gui wallpaper reset
    run_if_exists bar &
}

# TODO: move to personal
save 1862dc110979a186b3348600cb6836c7 desk-3 \
     xrandr --output LVDS1 --mode 1366x768 --pos 0x0 --rotate normal --output DP1 --mode 1366x768 --pos 2966x0 --rotate left --output DP2 --off --output DP3 --primary --mode 1600x900 --pos 1366x0 --rotate normal --output HDMI1 --off --output HDMI2 --off --output HDMI3 --off --output VGA1 --off --output VIRTUAL1 --off

