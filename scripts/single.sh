#!/bin/bash

# Disable a second monitor
xrandr --output HDMI1 --off
xrandr --output DP1 --off

# Map the touchscreen to the laptop screen
xinput --map-to-output 11 eDP1

notify-send "Second monitor disabled"
