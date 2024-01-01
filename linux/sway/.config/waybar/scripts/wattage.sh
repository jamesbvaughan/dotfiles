#!/bin/bash

microwatts=$(cat /sys/class/power_supply/BAT0/power_now)

watts=$(echo "scale=1; $microwatts / 1000000" | bc)

# other possible icons
# 󱐋
# 
# 󱐌
# 󰠠

echo "${watts}W"
