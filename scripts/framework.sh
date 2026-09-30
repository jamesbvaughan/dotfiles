#!/usr/bin/env python3
"""
Framework Laptop 13 Pro hardware controls for Quickshell & Hyprland.

  framework.sh kblight get|set N|up [N]|down [N]
  framework.sh charge-limit get|set N|toggle

The keyboard backlight is a plain LED class device, driven through brightnessctl
(which goes via logind, so no root). Only the charge limit needs framework_tool,
which needs `sudo -n` (NOPASSWD rule for /usr/bin/framework_tool). Fan speed and
the backlight level are read straight from sysfs by Quickshell's SystemStats, so
nothing here is polled.
"""

import re
import subprocess
import sys

TOOL = "/usr/bin/framework_tool"
KBD_LED = "chromeos::kbd_backlight"


def framework_tool(*args, timeout=2.0):
    try:
        res = subprocess.run(["sudo", "-n", TOOL, *args], capture_output=True, text=True, timeout=timeout)
        return res.stdout
    except Exception:
        return ""


def quickshell_ipc(method, *args):
    subprocess.run(["quickshell", "ipc", "call", "shell", method, *map(str, args)],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def get_kblight():
    res = subprocess.run(["brightnessctl", "-d", KBD_LED, "-m"], capture_output=True, text=True)
    m = re.search(r",(\d+)%,", res.stdout)
    return int(m.group(1)) if m else 0


def set_kblight(val):
    val = max(0, min(100, int(val)))
    subprocess.run(["brightnessctl", "-q", "-d", KBD_LED, "set", f"{val}%"],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    quickshell_ipc("triggerKblightOsd", val)
    return val


def get_charge_limit():
    m = re.search(r"Maximum\s*(\d+)%", framework_tool("--charge-limit"))
    return int(m.group(1)) if m else 100


def set_charge_limit(val):
    val = max(20, min(100, int(val)))
    framework_tool("--charge-limit", str(val))
    return val


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else ""
    sub = sys.argv[2] if len(sys.argv) > 2 else "get"
    arg = sys.argv[3] if len(sys.argv) > 3 else None

    if cmd == "kblight":
        if sub == "get":
            print(get_kblight())
        elif sub == "set":
            print(set_kblight(arg or 0))
        elif sub in ("up", "down"):
            delta = int(arg or 10) * (1 if sub == "up" else -1)
            print(set_kblight(get_kblight() + delta))
        else:
            sys.exit(f"Unknown kblight subcommand: {sub}")
    elif cmd == "charge-limit":
        if sub == "get":
            print(get_charge_limit())
        elif sub == "set":
            print(set_charge_limit(arg or 100))
        elif sub == "toggle":
            print(set_charge_limit(80 if get_charge_limit() >= 90 else 100))
        else:
            sys.exit(f"Unknown charge-limit subcommand: {sub}")
    else:
        sys.exit("Usage: framework.sh <kblight|charge-limit> [args...]")


if __name__ == "__main__":
    main()
