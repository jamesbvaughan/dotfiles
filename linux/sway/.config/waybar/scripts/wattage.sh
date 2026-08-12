#!/bin/bash

bat=/sys/class/power_supply/BAT1
microwatts=$(( $(cat "$bat/current_now") * $(cat "$bat/voltage_now") / 1000000 ))

watts=$(echo "scale=1; $microwatts / 1000000" | bc)

# other possible icons
# 󱐋
# 
# 󱐌
# 󰠠

echo "${watts}W"
