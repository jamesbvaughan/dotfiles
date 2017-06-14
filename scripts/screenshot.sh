#!/bin/sh

# Directory where you want to save screenshots
SCREENSHOT_DIR=~/Pictures/screenshots/

OPTIONS=$(echo -e "Entire Screen\nFocused Window\nSelection")
TYPE=$(echo "$OPTIONS" | rofi -dmenu -p "screenshot:")

case $TYPE in
	"Entire Screen") sleep 1 && scrot -e 'mv $f '$SCREENSHOT_DIR ;;
	"Focused Window") sleep 1 && scrot -u -e 'mv $f '$SCREENSHOT_DIR ;;
	"Selection") scrot -s -e 'mv $f '$SCREENSHOT_DIR ;;
esac

if [[ -n $TYPE ]]; then
	notify-send "Screenshot captured!"
fi
