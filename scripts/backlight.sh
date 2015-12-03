#!/bin/sh

# Get the current light level, rounded to an integer
LIGHT=$(printf '%.*f' 0 $(xbacklight -get))

# Set how much you want the brightness to change
DELTA=5

# If called from i3blocks, and scrolling, then change light level
if [ "$BLOCK_BUTTON" = 5 ];
then
	NEW_LIGHT=$(expr $LIGHT + $DELTA)
elif [ "$BLOCK_BUTTON" = 4 ];
then
	NEW_LIGHT=$(expr $LIGHT - $DELTA)
fi

xbacklight -set $NEW_LIGHT -time 0 -steps 1

# Output the new light level
echo $NEW_LIGHT
