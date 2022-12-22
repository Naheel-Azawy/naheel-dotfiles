#!/bin/sh

# sourced by shells to export personal additional paths
# `try_export` and `try_add_path` need to be defined per shell

try_add_path "$HOME/go/bin"
try_add_path "$HOME/.cargo/bin"
try_export JAVA_HOME /usr/lib/jvm/java-11-openjdk
