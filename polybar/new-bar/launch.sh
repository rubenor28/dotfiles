#!/bin/bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Launch Polybar, using default config location ~/.config/polybar/config.ini
# polybar gruvbox-bar 2>&1 | tee -a /tmp/polybar.log & disown
# polybar fullbar &
polybar workspace &
# polybar tray
polybar date &
# polybar batt &
# polybar temp &
# polybar files &
polybar pulse & 
# polybar cpu &
# polybar ram &
polybar ip-main &
polybar ip-htb &
polybar ip-target &

echo "Polybar launched..." 
