#!/bin/sh

# Get and print out the current battery level
CURRENT="$(cat /sys/class/power_supply/BAT1/capacity)"
echo   $CURRENT%

# Print out the color to display it in, based on the level
if test "$(cat /sys/class/power_supply/ACAD/online)" = 1; then
	echo
	echo \#22dd22
elif test "$CURRENT" -le 15; then
	echo
	echo \#dd2222
elif test "$CURRENT" -le 30; then
	echo
	echo \#dddd22
fi
