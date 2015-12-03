#!/bin/sh

# Helps make the network applet work
nm-applet    2>&1 /dev/null &
stalonetray  2>&1 /dev/null
killall nm-applet
