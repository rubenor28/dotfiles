
#!/usr/bin/env bash
batt_capacity=$(cat /sys/class/power_supply/BAT1/capacity)
echo "${batt_capacity}"
