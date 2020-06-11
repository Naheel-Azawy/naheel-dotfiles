#!/bin/sh

# sourced by shells to export personal additional paths
# `try_export` and `try_add_path` need to be defined per shell

# GO ########################################
try_add_path "$HOME/go/bin"

# ANDROID ###################################
try_export ANDROID_HOME /mnt/hdd1/Public/software/android/Sdk
try_export ANDROID_SDK_ROOT "$ANDROID_HOME"
try_add_path "$ANDROID_HOME/platform-tools"

# GAMES #####################################
try_export GAMES    /mnt/hdd1/Public/Games
try_export GAMES_XP "$GAMES/solitaire_xp/"
try_export GAMES_GB "$GAMES/gameboy"
try_export GAMES_PS "$GAMES/psx"

# MATLAB ####################################
try_export MATLAB /mnt/hdd1/Public/software/non-free-software/MATLAB/R2017a

# OTHERS ####################################
try_export QU       /mnt/hdd1/Private/Documents/QU
try_export QU_SCHED /mnt/hdd1/Private/Projects/qu-stuff/QUSchedule
try_export EVENTS   /mnt/hdd1/Private/Documents/events
try_export RESEARCH /mnt/hdd1/Private/Documents/research
try_export CERTS    /mnt/hdd1/Private/Documents/Certifications

