#!/bin/sh

# pause notifications while screen is locked
killall -SIGUSR1 dunst

# Turn off the screen
xset dpms force off

# Lower screen timeout
xset dpms 5 5 5

# Lock the screen
i3lock-wrapper --nofork --logo --ignore-empty-password

# Raise screen timeout
xset -dpms

# resume notifications when screen in unlocked
killall -SIGUSR2 dunst
