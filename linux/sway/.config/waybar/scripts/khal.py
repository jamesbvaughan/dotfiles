#!/usr/bin/env python3
"""Render upcoming khal events as Waybar JSON."""

from __future__ import annotations

import datetime as dt
import html
import json
import shutil
import subprocess
import sys

ICON = ""
LOOKAHEAD = "10d"
TOOLTIP_EVENTS = 10


def emit(text: str = ICON, tooltip: str = "") -> None:
    print(json.dumps({"text": text, "tooltip": tooltip}))


def when_label(event: dict[str, str], today: dt.date) -> str:
    date = dt.date.fromisoformat(event["start-date"])
    time = event.get("start-time", "")
    all_day = event.get("all-day") == "True"

    if date == today:
        return "all day" if all_day else time
    if date == today + dt.timedelta(days=1):
        return "tomorrow" if all_day else f"tomorrow {time}"
    label = date.strftime("%a %b %-d")
    return label if all_day else f"{label} {time}"


def main() -> None:
    if not shutil.which("khal"):
        emit(tooltip="khal is not installed")
        return

    try:
        result = subprocess.run(
            ["khal", "list", "--json", "all", "now", LOOKAHEAD],
            check=True,
            capture_output=True,
            text=True,
            timeout=15,
        )
        # khal emits one JSON array per day in the requested range.
        events = [
            event
            for line in result.stdout.splitlines()
            if line.strip()
            for event in json.loads(line)
            if event.get("cancelled") != "CANCELLED"
            and event.get("all-day") != "True"
        ]
    except subprocess.TimeoutExpired:
        emit(tooltip="Calendar query timed out")
        return
    except (subprocess.CalledProcessError, json.JSONDecodeError) as error:
        detail = getattr(error, "stderr", "") or str(error)
        emit(tooltip="Calendar unavailable\n" + html.escape(detail.strip()))
        return

    if not events:
        emit(tooltip="No events in the next 10 days")
        return

    today = dt.date.today()
    next_event = events[0]
    text = (
        f"{ICON}  {html.escape(when_label(next_event, today))}  "
        f"{html.escape(next_event.get('title', '(No title)'))}"
    )

    tooltip = ["<b>Upcoming events</b>"]
    for event in events[:TOOLTIP_EVENTS]:
        tooltip.append(
            f"{html.escape(when_label(event, today))}  "
            f"{html.escape(event.get('title', '(No title)'))}"
        )
    if len(events) > TOOLTIP_EVENTS:
        tooltip.append(f"…and {len(events) - TOOLTIP_EVENTS} more")

    emit(text, "\n".join(tooltip))


if __name__ == "__main__":
    try:
        main()
    except BrokenPipeError:
        sys.exit(0)
