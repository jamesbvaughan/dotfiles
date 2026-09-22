#!/usr/bin/env bash
# Turn displays off/on for idle blanking.
#
# Exists because the legacy form (`hyprctl dispatch dpms on`) is a hard error under
# Hyprland's Lua config -- it is evaluated as `hl.dispatch(dpms on)` and dies with a
# syntax error. swayidle ignored that failure, so the panel was never woken and the
# screen stayed dark while the session looked perfectly healthy.
#
# The action must also be a quoted string inside a table; a bare word silently
# degrades into a toggle.
set -euo pipefail

export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"

case "${1:-on}" in
  on)  action="enable" ;;
  off) action="disable" ;;
  *)   echo "usage: dpms.sh {on|off}" >&2; exit 1 ;;
esac

hyprctl dispatch "hl.dsp.dpms({ action = \"$action\" })" >/dev/null
