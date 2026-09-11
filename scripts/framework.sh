#!/usr/bin/env python3
"""
Framework Laptop 13 Pro management helper for Quickshell & Hyprland.
Provides fast JSON stats and hardware control via framework_tool.
"""

import sys
import re
import subprocess
import shutil

TOOL = "/usr/bin/framework_tool"

def run_cmd(args, timeout=2.0):
    cmd = ["sudo", "-n", TOOL] + args
    try:
        res = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, timeout=timeout)
        return res.stdout
    except Exception:
        return ""

def quickshell_ipc(method, *args):
    if not shutil.which("quickshell"):
        return
    args_str = " ".join(str(a) for a in args)
    call_str = f"{method} {args_str}".strip()
    subprocess.run(["quickshell", "ipc", "call", "shell", call_str],
                   stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def get_stats():
    import json
    stats = {
        "fan_rpm": 0,
        "charge_limit": 100,
        "camera": "connected",
        "mic": "connected",
        "kblight": 0,
    }

    # 1. Thermal / Fan
    thermal = run_cmd(["--thermal"])
    m_fan = re.search(r"Fan.*?:\s*(\d+)\s*RPM", thermal)
    if m_fan:
        stats["fan_rpm"] = int(m_fan.group(1))

    # 2. Charge Limit
    charge = run_cmd(["--charge-limit"])
    m_charge = re.search(r"Maximum\s*(\d+)%", charge)
    if m_charge:
        stats["charge_limit"] = int(m_charge.group(1))

    # 3. Privacy Switches
    privacy = run_cmd(["--privacy"])
    m_cam = re.search(r"Camera:\s*(\w+)", privacy)
    if m_cam:
        stats["camera"] = m_cam.group(1).lower()
    m_mic = re.search(r"Microphone:\s*(\w+)", privacy)
    if m_mic:
        stats["mic"] = m_mic.group(1).lower()

    # 4. Keyboard Backlight
    kb = run_cmd(["--kblight"])
    m_kb = re.search(r"Keyboard backlight:\s*(\d+)%", kb)
    if m_kb:
        stats["kblight"] = int(m_kb.group(1))

    return json.dumps(stats)

def get_kblight():
    kb = run_cmd(["--kblight"])
    m = re.search(r"Keyboard backlight:\s*(\d+)%", kb)
    return int(m.group(1)) if m else 0

def set_kblight(val):
    val = max(0, min(100, int(val)))
    run_cmd(["--kblight", str(val)])
    quickshell_ipc("triggerKblightOsd", val)
    return val

def toggle_charge_limit():
    charge = run_cmd(["--charge-limit"])
    m = re.search(r"Maximum\s*(\d+)%", charge)
    curr = int(m.group(1)) if m else 100
    target = 80 if curr >= 90 else 100
    run_cmd(["--charge-limit", str(target)])
    return target

def set_charge_limit(val):
    val = max(20, min(100, int(val)))
    run_cmd(["--charge-limit", str(val)])
    return val

def main():
    if len(sys.argv) < 2:
        print("Usage: framework.sh <stats|kblight|charge-limit> [args...]")
        sys.exit(1)

    cmd = sys.argv[1]

    if cmd == "stats":
        print(get_stats())
    elif cmd == "kblight":
        sub = sys.argv[2] if len(sys.argv) > 2 else "get"
        if sub == "get":
            print(get_kblight())
        elif sub == "set":
            val = int(sys.argv[3]) if len(sys.argv) > 3 else 0
            new_val = set_kblight(val)
            print(new_val)
        elif sub == "up":
            delta = int(sys.argv[3]) if len(sys.argv) > 3 else 10
            curr = get_kblight()
            new_val = set_kblight(curr + delta)
            print(new_val)
        elif sub == "down":
            delta = int(sys.argv[3]) if len(sys.argv) > 3 else 10
            curr = get_kblight()
            new_val = set_kblight(curr - delta)
            print(new_val)
        else:
            print(f"Unknown kblight subcommand: {sub}", file=sys.stderr)
            sys.exit(1)
    elif cmd == "charge-limit":
        sub = sys.argv[2] if len(sys.argv) > 2 else "get"
        if sub == "get":
            charge = run_cmd(["--charge-limit"])
            m = re.search(r"Maximum\s*(\d+)%", charge)
            print(int(m.group(1)) if m else 100)
        elif sub == "set":
            val = int(sys.argv[3]) if len(sys.argv) > 3 else 100
            print(set_charge_limit(val))
        elif sub == "toggle":
            print(toggle_charge_limit())
        else:
            print(f"Unknown charge-limit subcommand: {sub}", file=sys.stderr)
            sys.exit(1)
    else:
        print(f"Unknown command: {cmd}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
