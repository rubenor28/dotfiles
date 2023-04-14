#!/bin/sh
# network-tools package needed
echo "$(ifconfig eth0 | grep "inet " | awk '{print $2}')"
