#!/bin/sh
# network-tools package needed
device=$(cat ~/.config/polybar/scripts/ip-device)

echo "$(ifconfig "$device" | grep "inet " | awk '{print $2}')"
