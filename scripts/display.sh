#!/bin/sh

OPTIONS="Laptop\nHDMI\nDisplayPort\nLaptop+HDMI\nLaptop+DisplayPort\nHDMI+DisplayPort\nLaptop+HDMI+DisplayPort"
SELECTION=$(echo -e "$OPTIONS" | rofi -i -matching fuzzy -dmenu -p "displays:")

case $SELECTION in
  "Laptop" )
    xrandr \
      --output HDMI1 --off \
      --output eDP1 --auto \
      --output HDMI2 --off
    ;;
  "HDMI" )
    xrandr \
      --output HDMI1 --auto \
      --output eDP1 --off \
      --output HDMI2 --off
    ;;
  "DisplayPort" )
    xrandr \
      --output HDMI1 --off \
      --output eDP1 --off \
      --output HDMI2 --auto
    ;;
  "Laptop+HDMI" )
    xrandr \
      --output HDMI1 --auto \
      --output eDP1 --auto --right-of HDMI1 \
      --output HDMI2 --off
    ;;
  "Laptop+DisplayPort" )
    xrandr \
      --output HDMI1 --off \
      --output eDP1 --auto \
      --output HDMI2 --auto --right-of eDP1
    ;;
  "HDMI+DisplayPort" )
    xrandr \
      --output HDMI1 --auto \
      --output eDP1 --off \
      --output HDMI2 --auto --right-of HDMI1
    ;;
  "Laptop+HDMI+DisplayPort" )
    xrandr \
      --output HDMI1 --auto \
      --output eDP1 --auto --right-of HDMI1 \
      --output HDMI2 --auto --right-of eDP1
    ;;
esac

if [[ -n $SELECTION ]]; then
  sh ~/.fehbg &
  notify-send "Switched layout to $SELECTION"
fi
