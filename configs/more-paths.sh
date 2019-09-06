#!/bin/sh

try_export() {
    N="$1"
    F="$2"
    if [ -f "$F" ] || [ -d "$F" ]; then
        eval "export $N=\"$F\""
    fi
}

try_add_path() {
    F="$1"
    if [ -f "$F" ] || [ -d "$F" ]; then
        PATH="$PATH:$F"
    fi
}

# GO ########################################
try_add_path "$HOME/go/bin"

# ANDROID ###################################
try_export ANDROID_HOME /mnt/hdd1/GoodStuff2/Android/Sdk
try_export ANDROID_SDK_ROOT "$ANDROID_HOME"
try_add_path "$ANDROID_HOME/platform-tools"

# XP GAMES ##################################
try_export GAMES    /mnt/hdd2/GoodStuff2/Games
try_export GAMES_XP "$GAMES/solitaire_xp/"
try_export GAMES_GB "$GAMES/gameboy"
try_export GAMES_PS "$GAMES/psx"

# MATLAB ####################################
try_export MATLAB /mnt/hdd1/GoodStuff2/MATLAB/R2017a

# OTHERS ####################################
try_export QU       /mnt/hdd1/Documents/QU
try_export QU_SCHED /mnt/hdd1/Projects/qu-stuff/QUSchedule
try_export EVENTS   /mnt/hdd1/Documents/events
try_export RESEARCH /mnt/hdd1/Documents/research
try_export CERTS    /mnt/hdd1/Documents/Certifications

