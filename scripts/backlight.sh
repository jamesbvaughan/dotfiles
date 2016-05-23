#!/bin/sh

# Set how much you want the brightness to change
DELTA=5

# Get the current light level, rounded to an integer
LIGHT=$(printf '%.*f' 0 $(xbacklight -get))
NEW_LIGHT=$LIGHT

# If called from i3blocks, and scrolling, then change light level
case $BLOCK_BUTTON in
	5) NEW_LIGHT=$(expr $LIGHT + $DELTA) ;;
	4) NEW_LIGHT=$(expr $LIGHT - $DELTA) ;;
esac

xbacklight -set $NEW_LIGHT -time 0 -steps 1

# Output the new light level
printf '%.*f%%' 0 $(xbacklight -get)
