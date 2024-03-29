#!/bin/sh

# Generated with:
# $ gsettings-save org.onboard > "$DOTFILES_DIR/configs/onboard-gsettings.sh"

gsettings get org.onboard.window.landscape x >/dev/null 2>/dev/null || {
    echo Failed setting on-screen keyboard settings
    exit 1
}

THEME="$DOTFILES_DIR/configs/onboard-theme.xml"
gsettings set org.onboard.window.landscape width "660"
gsettings set org.onboard.window.landscape x "612"
gsettings set org.onboard.window.landscape dock-width "700"
gsettings set org.onboard.window.landscape y "858"
gsettings set org.onboard.window.landscape dock-expand "true"
gsettings set org.onboard.window.landscape dock-height "205"
gsettings set org.onboard.window.landscape height "187"
gsettings set org.onboard.window.portrait width "600"
gsettings set org.onboard.window.portrait x "100"
gsettings set org.onboard.window.portrait dock-width "600"
gsettings set org.onboard.window.portrait y "50"
gsettings set org.onboard.window.portrait dock-expand "true"
gsettings set org.onboard.window.portrait dock-height "200"
gsettings set org.onboard.window.portrait height "200"
gsettings set org.onboard.universal-access hide-click-type-window "true"
gsettings set org.onboard.universal-access enable-click-type-window-on-exit "true"
gsettings set org.onboard.universal-access drag-threshold "-1"
gsettings set org.onboard.scanner enabled "false"
gsettings set org.onboard.scanner interval-fast "0.050000000000000003"
gsettings set org.onboard.scanner mode "'Autoscan'"
gsettings set org.onboard.scanner device-detach "false"
gsettings set org.onboard.scanner alternate "false"
gsettings set org.onboard.scanner cycles "2"
gsettings set org.onboard.scanner device-button-map "{1: 0, 3: 5}"
gsettings set org.onboard.scanner backtrack "5"
gsettings set org.onboard.scanner user-scan "false"
gsettings set org.onboard.scanner device-name "'Default'"
gsettings set org.onboard.scanner interval "1.2"
gsettings set org.onboard.scanner device-key-map "@a{ii} {}"
gsettings set org.onboard.scanner feedback-flash "true"
gsettings set org.onboard.typing-assistance auto-capitalization "false"
gsettings set org.onboard.typing-assistance auto-correction "false"
gsettings set org.onboard.typing-assistance max-recent-languages "5"
gsettings set org.onboard.typing-assistance spell-check-backend "'hunspell'"
gsettings set org.onboard.typing-assistance recent-languages "@as []"
gsettings set org.onboard.typing-assistance active-language "''"
gsettings set org.onboard.icon-palette.portrait width "64"
gsettings set org.onboard.icon-palette.portrait y "50"
gsettings set org.onboard.icon-palette.portrait height "64"
gsettings set org.onboard.icon-palette.portrait x "100"
gsettings set org.onboard xembed-unity-greeter-offset-x "85.0"
gsettings set org.onboard layout "'/usr/share/onboard/layouts/Small.onboard'"
gsettings set org.onboard system-theme-associations "{'HighContrast': 'HighContrast', 'HighContrastInverse': 'HighContrastInverse', 'LowContrast': 'LowContrast', 'ContrastHighInverse': 'HighContrastInverse', 'Default': '', 'AdwaitaRefresh-darker': '$THEME'}"
gsettings set org.onboard use-system-defaults "false"
gsettings set org.onboard theme "'$THEME'"
gsettings set org.onboard key-label-overrides "@as []"
gsettings set org.onboard system-theme-tracking-enabled "true"
gsettings set org.onboard snippets "['0:Onboard\nHome:https://launchpad.net/onboard', '1:Example:Create your macros here.']"
gsettings set org.onboard show-tooltips "true"
gsettings set org.onboard start-minimized "false"
gsettings set org.onboard schema-version "'2.3'"
gsettings set org.onboard status-icon-provider "'auto'"
gsettings set org.onboard xembed-aspect-change-range "[0.0, 1.6000000000000001]"
gsettings set org.onboard xembed-onboard "false"
gsettings set org.onboard key-label-font "''"
gsettings set org.onboard current-settings-page "1"
gsettings set org.onboard xembed-background-color "'#0000007F'"
gsettings set org.onboard xembed-background-image-enabled "true"
gsettings set org.onboard show-status-icon "true"
gsettings set org.onboard.icon-palette.landscape width "64"
gsettings set org.onboard.icon-palette.landscape y "50"
gsettings set org.onboard.icon-palette.landscape height "64"
gsettings set org.onboard.icon-palette.landscape x "100"
gsettings set org.onboard.typing-assistance.word-suggestions delayed-word-separators-enabled "false"
gsettings set org.onboard.typing-assistance.word-suggestions enabled "false"
gsettings set org.onboard.typing-assistance.word-suggestions auto-learn "true"
gsettings set org.onboard.typing-assistance.word-suggestions max-word-choices "5"
gsettings set org.onboard.typing-assistance.word-suggestions spelling-suggestions-enabled "true"
gsettings set org.onboard.typing-assistance.word-suggestions pause-learning-locked "false"
gsettings set org.onboard.typing-assistance.word-suggestions show-context-line "false"
gsettings set org.onboard.typing-assistance.word-suggestions punctuation-assistance "true"
gsettings set org.onboard.typing-assistance.word-suggestions stealth-mode "false"
gsettings set org.onboard.typing-assistance.word-suggestions learning-behavior-paused "'nothing'"
gsettings set org.onboard.typing-assistance.word-suggestions accent-insensitive "true"
gsettings set org.onboard.typing-assistance.word-suggestions wordlist-buttons "['previous-predictions', 'next-predictions', 'language', 'hide']"
gsettings set org.onboard.window window-state-sticky "true"
gsettings set org.onboard.window docking-monitor "'active'"
gsettings set org.onboard.window docking-shrink-workarea "true"
gsettings set org.onboard.window transparency "0.0"
gsettings set org.onboard.window enable-inactive-transparency "true"
gsettings set org.onboard.window docking-enabled "false"
gsettings set org.onboard.window transparent-background "false"
gsettings set org.onboard.window keep-aspect-ratio "false"
gsettings set org.onboard.window window-handles "'E SE S SW W NW N NE M'"
gsettings set org.onboard.window inactive-transparency "5.0"
gsettings set org.onboard.window inactive-transparency-delay "1.0"
gsettings set org.onboard.window window-decoration "true"
gsettings set org.onboard.window docking-edge "'bottom'"
gsettings set org.onboard.window docking-aspect-change-range "[0.0, 2.0]"
gsettings set org.onboard.window background-transparency "10.0"
gsettings set org.onboard.window force-to-top "false"
gsettings set org.onboard.auto-show enabled "false"
gsettings set org.onboard.auto-show tablet-mode-detection-enabled "true"
gsettings set org.onboard.auto-show tablet-mode-state-file "''"
gsettings set org.onboard.auto-show hide-on-key-press-pause "1800.0"
gsettings set org.onboard.auto-show tablet-mode-enter-key "0"
gsettings set org.onboard.auto-show tablet-mode-state-file-pattern "'1'"
gsettings set org.onboard.auto-show reposition-method-floating "'prevent-occlusion'"
gsettings set org.onboard.auto-show reposition-method-docked "'prevent-occlusion'"
gsettings set org.onboard.auto-show keyboard-device-detection-enabled "false"
gsettings set org.onboard.auto-show hide-on-key-press "true"
gsettings set org.onboard.auto-show keyboard-device-detection-exceptions "@as []"
gsettings set org.onboard.auto-show tablet-mode-leave-key "0"
gsettings set org.onboard.auto-show widget-clearance "(25.0, 55.0, 25.0, 40.0)"
gsettings set org.onboard.lockdown disable-touch-handles "false"
gsettings set org.onboard.lockdown disable-keys "[['CTRL', 'LALT', 'F[0-9]+']]"
gsettings set org.onboard.lockdown disable-quit "false"
gsettings set org.onboard.lockdown disable-click-buttons "false"
gsettings set org.onboard.lockdown disable-hover-click "false"
gsettings set org.onboard.lockdown disable-dwell-activation "false"
gsettings set org.onboard.lockdown disable-preferences "false"
gsettings set org.onboard.keyboard long-press-delay "0.5"
gsettings set org.onboard.keyboard audio-feedback-enabled "false"
gsettings set org.onboard.keyboard input-event-source "'XInput'"
gsettings set org.onboard.keyboard touch-feedback-size "0"
gsettings set org.onboard.keyboard sticky-key-release-delay "0.0"
gsettings set org.onboard.keyboard sticky-key-behavior "{'all': 'cycle'}"
gsettings set org.onboard.keyboard audio-feedback-place-in-space "false"
gsettings set org.onboard.keyboard touch-input "'multi'"
gsettings set org.onboard.keyboard modifier-update-delay "1.0"
gsettings set org.onboard.keyboard touch-feedback-enabled "false"
gsettings set org.onboard.keyboard show-secondary-labels "false"
gsettings set org.onboard.keyboard key-synth "'auto'"
gsettings set org.onboard.keyboard sticky-key-release-on-hide-delay "5.0"
gsettings set org.onboard.keyboard show-click-buttons "false"
gsettings set org.onboard.keyboard default-key-action "'delayed-stroke'"
gsettings set org.onboard.keyboard key-press-modifiers "{'button3': 'SHIFT'}"
gsettings set org.onboard.keyboard inter-key-stroke-delay "0.0"
gsettings set org.onboard.theme-settings key-shadow-strength "0.0"
gsettings set org.onboard.theme-settings roundrect-radius "20.0"
gsettings set org.onboard.theme-settings key-stroke-gradient "8.0"
gsettings set org.onboard.theme-settings key-label-font "'Liberation Sans'"
gsettings set org.onboard.theme-settings key-label-overrides "@as []"
gsettings set org.onboard.theme-settings color-scheme "'/usr/share/onboard/themes/HighContrastInverseBlack.colors'"
gsettings set org.onboard.theme-settings key-shadow-size "0.0"
gsettings set org.onboard.theme-settings key-size "94.0"
gsettings set org.onboard.theme-settings key-gradient-direction "-3.0"
gsettings set org.onboard.theme-settings background-gradient "0.0"
gsettings set org.onboard.theme-settings key-stroke-width "0.0"
gsettings set org.onboard.theme-settings key-fill-gradient "8.0"
gsettings set org.onboard.theme-settings key-style "'flat'"
gsettings set org.onboard.icon-palette in-use "false"
gsettings set org.onboard.icon-palette window-handles "'E SE S SW W NW N NE M'"
