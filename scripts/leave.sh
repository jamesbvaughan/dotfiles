#!/bin/sh

OPTIONS=$(echo -e "Logout\nShutdown\nRestart")
COMMAND=$(echo "$OPTIONS" | rofi -dmenu -p "leave:")

case $COMMAND in
	"Logout") i3-msg exit ;;
	"Shutdown") systemctl poweroff ;;
	"Restart") systemctl reboot ;;
esac
