#!/bin/sh

# sourced by shells to export personal additional paths
# `try_export` and `try_add_path` need to be defined per shell

try_add_path "$HOME/go/bin"
try_add_path "$HOME/.cargo/bin"
try_export JAVA_HOME /usr/lib/jvm/java-11-openjdk

# ANDROID ###################################
# TODO: move to personal
try_export ANDROID_HOME /mnt/hdd1/Public/software/android/Sdk
try_export ANDROID_SDK_ROOT "$ANDROID_HOME"
try_add_path "$ANDROID_HOME/platform-tools"
