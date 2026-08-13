#!/usr/bin/env python3
import json
import os
import sys
import subprocess

def get_outputs():
    try:
        out = subprocess.check_output(["swaymsg", "-t", "get_outputs"], stderr=subprocess.DEVNULL)
        return json.loads(out)
    except Exception:
        return []

def format_hz(mhz):
    hz = mhz / 1000.0
    if mhz % 1000 == 0:
        return f"{int(hz)}Hz"
    else:
        return f"{hz:.2f}".rstrip('0').rstrip('.') + "Hz"

def main():
    toggle = "--toggle" in sys.argv or "-t" in sys.argv or "toggle" in sys.argv
    
    outputs = get_outputs()
    if not outputs:
        print(json.dumps({"text": "N/A", "tooltip": "Unable to query Sway outputs"}))
        return

    # Determine target output: WAYBAR_OUTPUT_NAME -> argument -> focused output -> first output
    target_name = os.environ.get("WAYBAR_OUTPUT_NAME")
    if not target_name:
        for arg in sys.argv[1:]:
            if not arg.startswith("-") and arg != "toggle":
                target_name = arg
                break

    output = None
    if target_name:
        output = next((o for o in outputs if o.get("name") == target_name), None)
    if not output:
        output = next((o for o in outputs if o.get("focused")), outputs[0])

    output_name = output.get("name", "unknown")
    current_mode = output.get("current_mode", {})
    w = current_mode.get("width")
    h = current_mode.get("height")
    r_mhz = current_mode.get("refresh")

    if not w or not h or not r_mhz:
        print(json.dumps({"text": "N/A", "tooltip": f"Output {output_name} has no mode info"}))
        return

    modes = output.get("modes", [])
    # Find all refresh rates available for the current resolution
    rates_mhz = sorted(list(set(m["refresh"] for m in modes if m.get("width") == w and m.get("height") == h)))
    if not rates_mhz:
        rates_mhz = [r_mhz]

    if toggle and len(rates_mhz) > 1:
        # Find index of current refresh rate (closest match)
        curr_idx = min(range(len(rates_mhz)), key=lambda i: abs(rates_mhz[i] - r_mhz))
        next_idx = (curr_idx + 1) % len(rates_mhz)
        next_mhz = rates_mhz[next_idx]
        next_hz = next_mhz / 1000.0

        if next_mhz % 1000 == 0:
            hz_spec = f"{int(next_hz)}Hz"
        else:
            hz_spec = f"{next_hz:.3f}".rstrip('0').rstrip('.') + "Hz"

        mode_spec = f"{w}x{h}@{hz_spec}"
        try:
            subprocess.run(["swaymsg", "output", output_name, "mode", mode_spec], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        except Exception:
            pass

        # Signal Waybar to refresh
        subprocess.run(["pkill", "-RTMIN+2", "waybar"], stderr=subprocess.DEVNULL)
        return

    curr_hz_str = format_hz(r_mhz)
    text = f"{w}x{h} @ {curr_hz_str}"

    rates_str = ", ".join(format_hz(r) for r in rates_mhz)
    tooltip = (
        f"Display: {output_name}\n"
        f"Resolution: {w}x{h}\n"
        f"Current Frame Rate: {curr_hz_str}\n"
        f"Available Frame Rates: {rates_str}\n"
        f"(Click to toggle)"
    )

    print(json.dumps({
        "text": text,
        "tooltip": tooltip,
        "class": "display-mode"
    }))

if __name__ == "__main__":
    main()
