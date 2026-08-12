#!/bin/sh

# Waybar wrapper around the shared brightness script. Emits JSON so the module
# can pick its icon from the percentage; waybar's built-in backlight module
# can't be used here because it only reads /sys/class/backlight, which the
# Studio Display never appears in.

set -eu

percent=$("$HOME/.dotfiles/scripts/brightness.sh" get)
printf '{"text":"%s","percentage":%s}\n' "$percent" "$percent"
