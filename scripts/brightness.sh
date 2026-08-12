#!/bin/sh

# Adjust or report the brightness of whichever display is actually in use.
#
#   brightness.sh up | down | get
#
# The internal panel goes through /sys/class/backlight, which brightnessctl
# drives. The Studio Display has no backlight class device and doesn't speak
# DDC/CI, so ddcutil and brightnessctl can't see it at all - it takes a HID
# feature report on its hidraw node instead, which is what asdbctl sends.
# asdbctl also ships the udev rule that makes that node writable without root.
#
# Routing: with the lid open, eDP-1 is active and this drives the laptop panel.
# Docked with the lid shut, the lid:on bindswitch in the sway config disables
# eDP-1, so we fall through to the Studio Display.
#
# The steps differ between the two - 5% internal, asdbctl's built-in 10% for
# the Studio Display. Not worth the arithmetic to reconcile.

set -eu

action=${1:-}
case $action in
  up | down | get) ;;
  *) echo "usage: ${0##*/} up|down|get" >&2; exit 1 ;;
esac

# Both branches print the resulting percentage on stdout, for wob and waybar.
internal() {
  case $action in
    up) brightnessctl set +5% >/dev/null ;;
    down) brightnessctl set 5%- >/dev/null ;;
  esac
  brightnessctl -m | cut -d, -f4 | tr -d '%'
}

studio_display() {
  case $action in
    up | down) asdbctl "$action" >/dev/null 2>&1 || return 1 ;;
  esac
  percent=$(asdbctl get 2>/dev/null | sed -En 's/^brightness ([0-9]+)$/\1/p')
  [ -n "$percent" ] || return 1
  echo "$percent"
}

if [ "$(swaymsg -t get_outputs -r | jq '[.[] | select(.name == "eDP-1" and .active)] | length')" -gt 0 ]; then
  internal
else
  # Fall back to the internal panel if the display is unplugged or asleep.
  studio_display || internal
fi

# Nudge waybar's custom/brightness module rather than making it poll quickly.
if [ "$action" != get ]; then
  pkill -RTMIN+1 waybar 2>/dev/null || true
fi
