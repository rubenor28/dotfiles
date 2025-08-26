
#!/usr/bin/env bash
batt_capacity=$(cat /sys/class/power_supply/BAT0/capacity)
echo "${batt_capacity}"
