#!/usr/bin/env bash
# Lock the session with Quickshell, falling back to hyprlock.
#
# Pass --sleep when locking before suspend: it holds the caller (and therefore
# swayidle's systemd sleep inhibitor) until the lock surface is actually up, and
# verifies Quickshell survived. Without that wait the machine can suspend
# mid-handshake; Quickshell then dies still owning the ext-session-lock, and
# Hyprland comes back to the "lockscreen crashed" screen with no way in.
#
# Never block: swayidle waits for before-sleep hooks to return, so a foreground
# locker would hold the inhibitor open and the machine would never suspend.
set -uo pipefail

export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"

if quickshell ipc call shell lock 2>/dev/null; then
  [[ "${1:-}" != "--sleep" ]] && exit 0
  sleep 0.5
  pgrep -x quickshell >/dev/null && exit 0
fi

# Quickshell is absent, refused, or crashed while locking.
if [[ "${1:-}" == "--sleep" ]]; then
  hyprlock &
  sleep 0.5
else
  hyprlock --grace 10 &
fi
