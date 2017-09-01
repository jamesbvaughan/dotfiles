#!/bin/bash
intern=eDP-1
extern=HDMI-1

if xrandr | grep "$extern disconnected"; then
    xrandr --output "$extern" --off --output "$intern" --auto
else
    xrandr --output "$extern" --auto --above "$intern" --output "$intern" --auto
fi
