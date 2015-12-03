#!/bin/bash

# Disable a second monitor
xrandr --output HDMI1 --off
xrandr --output DP1 --off
echo "Second monitor disabled"
