#!/bin/sh

# Terminate already running bar instances
killall --quiet polybar

# Wait until the processes have been shut down
while pgrep --exact polybar >/dev/null; do sleep 1; done

# Launch the bar
polybar jamesbar &


echo "Polybar launched."
