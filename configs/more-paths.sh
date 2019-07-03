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

# ANDROID ###################################
try_export ANDROID_HOME /mnt/hdd1/GoodStuff2/Android/Sdk
try_export ANDROID_SDK_ROOT "$ANDROID_HOME"
try_add_path "$ANDROID_HOME/platform-tools"

# NS2 #######################################
NS2_PATH=/mnt/hdd1/GoodStuff
# LD_LIBRARY_PATH
OTCL_LIB=$NS2_PATH/ns-allinone-2.35/otcl-1.14
NS2_LIB=$NS2_PATH/ns-allinone-2.35/lib
X11_LIB=/usr/X11R6/lib
USR_LOCAL_LIB=/usr/local/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$OTCL_LIB:$NS2_LIB:$X11_LIB:$USR_LOCAL_LIB
# TCL_LIBRARY
TCL_LIB=$NS2_PATH/ns-allinone-2.35/tcl8.5.10/library
USR_LIB=/usr/lib
export TCL_LIBRARY=$TCL_LIB:$USR_LIB
# PATH
XGRAPH=$NS2_PATH/ns-allinone-2.35/bin:$NS2_PATH/ns-allinone-2.35/tcl8.5.10/unix:$NS2_PATH/ns-allinone-2.35/tk8.5.10/unix
#the above two lines beginning from xgraph and ending with unix should come on the same line
NS=$NS2_PATH/ns-allinone-2.35/ns-2.35/
NAM=$NS2_PATH/ns-allinone-2.35/nam-1.15/
try_add_path "$XGRAPH"
try_add_path "$NS"
try_add_path "$NAM"

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

