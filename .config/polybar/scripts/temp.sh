#!/usr/bin/env bash
cpu_temp=$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))
echo "${cpu_temp}"
