set fish_greeting ""

function cd..; cd ..; end
function e; exit 0; end
function ee; e; end
function ث; e; end
function l; ls -lh --color $argv | more; end
function c; clear; end
function h; history; end
function gh; history | grep $argv; end
function m; tmux $argv; end
function r; ranger $argv; end
function mkdircd; mkdir $argv; and cd $argv; end

