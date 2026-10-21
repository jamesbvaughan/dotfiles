#!/usr/bin/env bash
# swayidle's before-sleep / after-resume hook (see hyprland.lua).
#
#   sleep-hook.sh before | after
#
# swayidle keeps only ONE command per event -- a second `before-sleep` silently replaces
# the first -- so everything that must happen around a suspend lives here.
#
# before: runs while swayidle holds its sleep-delay inhibitor, so the suspend waits for it.
#   Park the lock screen's fingerprint reader first: a scan still running when the machine
#   suspends leaves fprintd holding a wedged device that fails every attempt after wake.
# after: let the fingerprint reader start again, and re-run update_monitors() in case a lid
#   or dock hotplug event was missed while asleep.
set -uo pipefail

scripts="$(dirname "$(readlink -f "$0")")"

case "${1:-}" in
  before)
    quickshell ipc call shell prepareForSleep 2>/dev/null
    playerctl pause 2>/dev/null
    "$scripts/lock.sh" --sleep
    ;;
  after)
    quickshell ipc call shell resumedFromSleep 2>/dev/null
    hyprctl reload config-only >/dev/null
    ;;
  *)
    echo "usage: ${0##*/} before|after" >&2
    exit 1
    ;;
esac
