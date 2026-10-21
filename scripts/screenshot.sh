#!/usr/bin/env bash
# Take a screenshot into ~/screenshots (also copied to the clipboard), then show a
# notification with an Edit button that opens it in satty for markup.
#
#   screenshot.sh area | output
#
# Clicking the notification opens the image in the default viewer. In satty, Enter copies
# the marked-up image to the clipboard, saves it next to the original as *-edited.png and
# quits; Ctrl+C / Ctrl+S do just one of those.
set -uo pipefail

target=${1:-area}
case $target in
  area | output) ;;
  *) echo "usage: ${0##*/} area|output" >&2; exit 1 ;;
esac

dir="$HOME/screenshots"
mkdir -p "$dir"
file="$dir/screenshot-at-$(date +%Y-%m-%d-%H-%M-%S).png"

# A cancelled area selection leaves no file; nothing to announce then
grimshot savecopy "$target" "$file" >/dev/null 2>&1
[ -f "$file" ] || exit 0

# notify-send -A blocks until an action is picked or the notification is dismissed, so the
# rest runs in the background: the keybind returns at once, and the Edit button keeps
# working from the Control Center after the toast has gone.
(
  action=$(notify-send -a grimshot -h "string:image-path:$file" \
    -A default=Open -A edit=Edit \
    "Screenshot saved" "${file##*/} (copied to clipboard)")
  case $action in
    edit)
      satty --filename "$file" \
        --output-filename "${file%.png}-edited.png" \
        --copy-command wl-copy \
        --actions-on-enter save-to-clipboard,save-to-file,exit \
        --disable-notifications
      ;;
    default)
      xdg-open "$file"
      ;;
  esac
) >/dev/null 2>&1 &
