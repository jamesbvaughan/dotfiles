#!/bin/sh

# Adjust or report the brightness of whichever display is actually in use.
#
#   brightness.sh up | down | get
#
# - The internal panel goes through /sys/class/backlight via brightnessctl.
# - Apple Studio Displays and Pro Display XDR take HID feature reports
#   over USB (driven by asdbctl or asdcontrol).
# - Standard external monitors communicate via DDC/CI (ddcutil).
#
# Routing:
# - If an external display is currently focused, adjust that display.
# - If the internal laptop panel (eDP-1) is focused, adjust internal.
# - If focus cannot be determined:
#   - If only external is active (clamshell mode), adjust external.
#   - Otherwise fallback to internal panel.
# - If external adjustment fails, always falls back to internal panel.

set -eu

STEP=5

action=${1:-}
case $action in
  up | down | get) ;;
  *) echo "usage: ${0##*/} up|down|get" >&2; exit 1 ;;
esac

# Both branches print the resulting percentage on stdout, for wob, waybar, and quickshell.
internal() {
  case $action in
    up) brightnessctl -c backlight set "+${STEP}%" >/dev/null 2>&1 ;;
    down) brightnessctl -c backlight set "${STEP}%-" >/dev/null 2>&1 ;;
  esac
  brightnessctl -c backlight -m 2>/dev/null | cut -d, -f4 | tr -d '%'
}

external_display() {
  # 1. Try asdbctl (Apple Studio Display / Studio Display XDR)
  if percent=$(asdbctl get 2>/dev/null | sed -En 's/^brightness ([0-9]+)$/\1/p'); [ -n "$percent" ]; then
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
    return 0
  fi

  # 2. Try asdcontrol if available (supports Apple Pro Display XDR PID 0x9243)
  if command -v asdcontrol >/dev/null 2>&1; then
    for dev in /dev/usb/hiddev* /dev/hiddev*; do
      [ -e "$dev" ] || continue
      case $action in
        up)
          out=$(asdcontrol --brief "$dev" "+${STEP}%" 2>/dev/null || true)
          ;;
        down)
          out=$(asdcontrol --brief "$dev" "--" "-${STEP}%" 2>/dev/null || true)
          ;;
        get)
          out=$(asdcontrol --brief "$dev" 2>/dev/null || true)
          ;;
      esac
      if [ -n "$out" ]; then
        echo "$out"
        return 0
      fi
    done
  fi

  # 3. Try ddcutil if available (standard external monitors with DDC/CI)
  if command -v ddcutil >/dev/null 2>&1; then
    case $action in
      up) ddcutil setvcp 10 + "$STEP" >/dev/null 2>&1 || true ;;
      down) ddcutil setvcp 10 - "$STEP" >/dev/null 2>&1 || true ;;
    esac
    cur=$(ddcutil getvcp 10 2>/dev/null | grep -oP 'current value =\s*\K[0-9]+' || true)
    if [ -n "$cur" ]; then
      echo "$cur"
      return 0
    fi
  fi

  return 1
}

# Returns the connector name of the currently focused monitor (e.g. "DP-1" or "eDP-1")
get_focused_monitor() {
  if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ] || pgrep -x Hyprland >/dev/null; then
    hyprctl monitors -j 2>/dev/null | jq -r '.[] | select(.focused) | .name' 2>/dev/null || true
  elif [ -n "${SWAYSOCK:-}" ] || pgrep -x sway >/dev/null; then
    if [ -z "${SWAYSOCK:-}" ]; then
      SWAYSOCK=$(ls /run/user/"$(id -u)"/sway-ipc.*.sock 2>/dev/null | head -n 1 || true)
      [ -n "$SWAYSOCK" ] && export SWAYSOCK
    fi
    swaymsg -t get_outputs -r 2>/dev/null | jq -r '.[] | select(.focused) | .name' 2>/dev/null || true
  fi
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
    count=$(hyprctl monitors -j 2>/dev/null | jq '[.[] | select(.name == "eDP-1" and (.disabled | not))] | length' 2>/dev/null || true)
    [ "${count:-0}" -gt 0 ] 2>/dev/null || return 1
  else
    return 0
  fi
}

focused=$(get_focused_monitor)

if [ "$focused" = "eDP-1" ]; then
  result=$(internal)
elif [ -n "$focused" ]; then
  # An external display is currently focused
  result=$(external_display || internal)
elif laptop_active; then
  # Fallback if focus is indeterminate but laptop screen is on
  result=$(internal)
else
  # Docked with laptop screen off, or only external display available
  result=$(external_display || internal)
fi

echo "$result"

# Nudge waybar or quickshell
if [ "$action" != get ]; then
  pkill -RTMIN+1 waybar 2>/dev/null || true
  quickshell ipc call shell triggerBrightnessOsd "${result%.*}" 2>/dev/null || true
fi
