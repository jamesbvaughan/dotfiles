#!/bin/sh

# Lock the screen
killall -SIGUSR1 dunst # pause notifications while screen is locked
scrot -z /tmp/scrot.png # Take a screenshot
convert /tmp/scrot.png -blur 0x8 /tmp/scrot.png # blur that screenshot
composite -gravity center /home/james/.bin/images/lock-icon.png /tmp/scrot.png /tmp/scrot.png # composite a lock image with the screenshot
i3lock -ef -i /tmp/scrot.png # lock the screen
killall -SIGUSR2 dunst # resume notifications when screen in unlocked
