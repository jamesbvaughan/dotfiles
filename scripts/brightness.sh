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
# Both devices adjust in increments configured by STEP.

set -eu

STEP=5

action=${1:-}
case $action in
  up | down | get) ;;
  *) echo "usage: ${0##*/} up|down|get" >&2; exit 1 ;;
esac

# Both branches print the resulting percentage on stdout, for wob and waybar.
internal() {
  case $action in
    up) brightnessctl -c backlight set "+${STEP}%" >/dev/null 2>&1 ;;
    down) brightnessctl -c backlight set "${STEP}%-" >/dev/null 2>&1 ;;
  esac
  brightnessctl -c backlight -m 2>/dev/null | cut -d, -f4 | tr -d '%'
}

studio_display() {
  percent=$(asdbctl get 2>/dev/null | sed -En 's/^brightness ([0-9]+)$/\1/p')
  [ -n "$percent" ] || return 1

  case $action in
    up)
      percent=$((percent + STEP > 100 ? 100 : percent + STEP))
      asdbctl set "$percent" >/dev/null 2>&1 || return 1
      ;;
    down)
      percent=$((percent - STEP < 0 ? 0 : percent - STEP))
      asdbctl set "$percent" >/dev/null 2>&1 || return 1
      ;;
  esac
  echo "$percent"
}

laptop_active() {
  if [ -z "${SWAYSOCK:-}" ]; then
    SWAYSOCK=$(ls /run/user/"$(id -u)"/sway-ipc.*.sock 2>/dev/null | head -n 1 || true)
    [ -n "$SWAYSOCK" ] && export SWAYSOCK
  fi

  if [ -n "${SWAYSOCK:-}" ] || pgrep -x sway >/dev/null; then
    count=$(swaymsg -t get_outputs -r 2>/dev/null | jq '[.[] | select(.name == "eDP-1" and .active)] | length' 2>/dev/null || true)
    [ "${count:-0}" -gt 0 ] 2>/dev/null || return 1
  elif [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ] || pgrep -x Hyprland >/dev/null; then
    count=$(hyprctl monitors -j 2>/dev/null | jq '[.[] | select(.name == "eDP-1")] | length' 2>/dev/null || true)
    [ "${count:-0}" -gt 0 ] 2>/dev/null || return 1
  else
    return 0
  fi
}

if laptop_active; then
  result=$(internal)
else
  # Fall back to the internal panel if the display is unplugged or asleep.
  result=$(studio_display || internal)
fi

echo "$result"

# Nudge waybar or quickshell
if [ "$action" != get ]; then
  pkill -RTMIN+1 waybar 2>/dev/null || true
  quickshell ipc call shell triggerBrightnessOsd "${result%.*}" 2>/dev/null || true
fi
