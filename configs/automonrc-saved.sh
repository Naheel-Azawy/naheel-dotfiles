
# automon sum | clipboard

# TODO: move to personal

for hsh in 1862dc110979a186b3348600cb6836c7 \
               93e18afbe5a67eed567e174153d717ac \
               6acbde4c20b7b62be2ce9ff901b30bf0; do
    save $hsh  desk-3 xrandr \
         --output LVDS1 --mode 1366x768 --pos 0x0 --rotate normal            \
         --output DP2 --mode 1280x720 --pos 2966x0 --rotate left             \
         --output DP3 --primary --mode 1600x900 --pos 1366x0 --rotate normal \
         --output DP1 --off   \
         --output HDMI1 --off \
         --output HDMI2 --off \
         --output HDMI3 --off \
         --output VGA1 --off  \
         --output VIRTUAL1 --off
done

save a43f993ce60afc8b42b110dae1065118 sg-lab xrandr \
     --output LVDS1 --primary --mode 1366x768 --pos 0x0 --rotate normal \
     --output VGA1 --mode 1680x1050 --pos 1366x0 --rotate left          \
     --output DP1 --off   \
     --output DP2 --off   \
     --output DP3 --off   \
     --output HDMI1 --off \
     --output HDMI2 --off \
     --output HDMI3 --off \
     --output VIRTUAL1 --off

save d6a036c70c8910af2813c69b17a83bc6 sg-lab-2 xrandr \
     --output LVDS1 --primary --mode 1366x768 --pos 1920x0 --rotate normal \
     --output DP1 --mode 1920x1080 --pos 0x0 --rotate normal \
     --output DP2 --off --output DP3 --off --output HDMI1 --off --output HDMI2 --off --output HDMI3 --off --output VGA1 --off --output VIRTUAL1 --off

save 1d1f9b61d37e5cebdbe8e230359a8aa4 x1-sg-lab xrandr \
     --output eDP-1 --primary --mode 1920x1200 --pos 0x0 --rotate normal --output HDMI-1 --off --output DP-1 --off --output DP-2 --off --output DP-3 --mode 1680x1050 --pos 1920x0 --rotate left --output DP-4 --off

save cb5cb15c6c75e4feb82d30f0f9e6939d x1-sg-lab-3 xrandr \
     --output eDP-1 --mode 1920x1200 --pos 0x1080 --rotate normal --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output DP-2 --off --output DP-3 --mode 1680x1050 --pos 1920x0 --rotate left --output DP-4 --off

save e1afc73e010ac024dcffa8020c850d77 x1-off xrandr \
     --output eDP-1 --mode 1920x1200 --pos 0x0 --rotate normal --output HDMI-1 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output DP-1 --off --output DP-2 --off --output DP-3 --off --output DP-4 --off

save 74881a811e4a9789c30e13b4a305d34e x1-off-2 xrandr \
     --output eDP-1 --mode 1920x1200 --pos 1920x0 --rotate normal --output HDMI-1 --off --output DP-1 --off --output DP-2 --off --output DP-3 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-4 --off
