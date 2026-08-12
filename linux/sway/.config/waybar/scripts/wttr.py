#!/usr/bin/env python3

# Location is resolved via GeoClue when possible; wttr.in's own IP-based
# geolocation is the fallback. The latter is what motivated this change — it
# sometimes resolves to the wrong city even when sitting on home WiFi.
#
# Setup on a new machine (Arch Linux):
#   - Install `geoclue` (>=2.7) and `python-gobject`. geoclue.service is
#     static/socket-activated; no `systemctl enable` needed.
#   - The default WiFi backend (beacondb) has almost no AP coverage in
#     practice and silently degrades to IP geolocation, which is the
#     problem we were trying to escape. Swap it for Google's Geolocation
#     API, which has effectively-complete BSSID coverage from Android:
#       1. In Google Cloud Console, make a project, enable the
#          "Geolocation API", create an API key, and restrict the key to
#          that single API so a leak can't run up other charges.
#       2. In /etc/geoclue/geoclue.conf, under [wifi], uncomment the
#          googleapis URL and substitute the key:
#            url=https://www.googleapis.com/geolocation/v1/geolocate?key=YOUR_KEY
#       3. `sudo systemctl restart geoclue` and verify with:
#            /usr/lib/geoclue-2.0/demos/where-am-i -a 6
#          Look for "Description: WiFi" rather than "GeoIP (ichnaea)" —
#          that, not the accuracy number, is the signal the Google backend
#          is being used. Expect a few km: Google returns coarse results
#          for these APs even though it locates them, which is still ample
#          for a city name. If it stays on GeoIP, the WiFi source isn't
#          reaching Google — check that NetworkManager is the active WiFi
#          manager (not bare iwd) and that geoclue's logs
#          (`journalctl -u geoclue`) don't show "WiFi scan failed".
#          Note this demo needs an agent running too, same as the script.
#     Positon (`https://api.positon.xyz/v1/geolocate?key=...`, free key
#     inline in geoclue.conf) is a no-signup alternative with worse
#     coverage than Google but better than beacondb — worth trying first
#     if you'd rather skip the Google Cloud setup.
#   - A GeoClue agent MUST be running. On 2.8 the daemon blocks
#     Manager.GetClient until one registers — it does not deny, it just
#     never answers, so every call here dies on the 25s D-Bus timeout and
#     falls through to the IP geolocation this script exists to avoid.
#     Desktop environments ship an agent; bare sway does not, so the demo
#     agent runs as a user service (geoclue-agent.service in this repo,
#     under linux/systemd). To check: `systemctl --user status
#     geoclue-agent`, or confirm the daemon answers at all with
#       busctl --system call org.freedesktop.GeoClue2 \
#         /org/freedesktop/GeoClue2/Manager \
#         org.freedesktop.GeoClue2.Manager GetClient
#     which returns an object path promptly when an agent is present and
#     times out when one is not.
#   - No allowlist entry is required: the app_id below is authorized by
#     the agent at Start time. If a future setup ever denies access, add
#     this block to /etc/geoclue/geoclue.conf (the app_id must match the
#     string passed to Geoclue.Simple.new_sync below):
#       [wttr]
#       allowed=true
#       system=false

import html
import json
import sys
import requests
from datetime import datetime

WEATHER_CODES = {
    '113': '☀️',
    '116': '⛅️',
    '119': '☁️',
    '122': '☁️',
    '143': '🌫',
    '176': '🌦',
    '179': '🌧',
    '182': '🌧',
    '185': '🌧',
    '200': '⛈',
    '227': '🌨',
    '230': '❄️',
    '248': '🌫',
    '260': '🌫',
    '263': '🌦',
    '266': '🌦',
    '281': '🌧',
    '284': '🌧',
    '293': '🌦',
    '296': '🌦',
    '299': '🌧',
    '302': '🌧',
    '305': '🌧',
    '308': '🌧',
    '311': '🌧',
    '314': '🌧',
    '317': '🌧',
    '320': '🌨',
    '323': '🌨',
    '326': '🌨',
    '329': '❄️',
    '332': '❄️',
    '335': '❄️',
    '338': '❄️',
    '350': '🌧',
    '353': '🌦',
    '356': '🌧',
    '359': '🌧',
    '362': '🌧',
    '365': '🌧',
    '368': '🌨',
    '371': '❄️',
    '374': '🌧',
    '377': '🌧',
    '386': '⛈',
    '389': '🌩',
    '392': '⛈',
    '395': '❄️'
}

data = {}

# Ways the location lookup degraded this run. Falling back silently is how
# this module spent a long time confidently reporting a city 40 miles away:
# GeoClue was timing out, the bare `except` below swallowed it, and wttr.in's
# IP guess looked exactly like a normal reading. The fallbacks are still the
# right behaviour for a status bar — they just shouldn't be invisible.
warnings = []


def warn(message, exc=None):
    """Record a degradation, and print it to stderr.

    stderr specifically: waybar parses this script's stdout as JSON, so a
    stray line there takes the whole module out. Read these back with
    `journalctl --user -t waybar` or wherever sway's output is going.
    """
    print(f"wttr: {message}" + (f": {exc!r}" if exc is not None else ""),
          file=sys.stderr)
    warnings.append(message)


# Accuracy, in metres, that's good enough to stop waiting for a better
# fix. Only the nearest city is displayed, so this needs to be nowhere near
# the tens of metres GeoClue can manage at best. Google's WiFi lookup
# typically answers ~3km here, so a tighter bound than that just burns the
# full timeout below on every refresh before using the same fix anyway.
GOOD_ENOUGH_ACCURACY_M = 5000

# How long to keep waiting for a fix that beats GOOD_ENOUGH_ACCURACY_M.
# The WiFi fix lands ~6s after the instant GeoIP one, because GeoClue has to
# drive a fresh wpa_supplicant scan first — anything under that is a coin
# flip between the two, which is what made the reported city jump around.
# The loop exits as soon as the WiFi fix arrives, so this is a ceiling, not
# a cost paid every refresh, and the module only polls every 300s anyway.
FIX_TIMEOUT_MS = 15000

# Decimal places kept in the coordinates sent to wttr.in. 2dp is ~1.1km,
# still finer than the fix we get, so this discards no real precision — but
# it stops the label flapping between neighbourhoods ("North Beach", "North
# Point Public Housing", ...) as the fix wanders by a few hundred metres
# between refreshes, and keeps exact coordinates off a third-party service.
COORD_DECIMALS = 2


def get_location():
    """Return 'lat,lon' from GeoClue, or None on any failure.

    Waits briefly after the first fix: GeoClue emits an IP-based estimate
    first (sub-second) and a WiFi-based one ~1-2s later. Returning on the
    first signal gives us the IP fix and lands us kilometres off.
    """
    try:
        import gi
        gi.require_version("Geoclue", "2.0")
        from gi.repository import Geoclue, GLib

        clue = Geoclue.Simple.new_sync(
            "wttr", Geoclue.AccuracyLevel.NEIGHBORHOOD, None
        )

        loop = GLib.MainLoop()
        best = [clue.get_location()]

        def on_notify(*_):
            loc = clue.get_location()
            if loc.get_property("accuracy") < best[0].get_property("accuracy"):
                best[0] = loc
            if best[0].get_property("accuracy") < GOOD_ENOUGH_ACCURACY_M:
                loop.quit()

        clue.connect("notify::location", on_notify)

        if best[0].get_property("accuracy") >= GOOD_ENOUGH_ACCURACY_M:
            GLib.timeout_add(FIX_TIMEOUT_MS, lambda: loop.quit() or False)
            loop.run()

        loc = best[0]
        lat = round(loc.get_property("latitude"), COORD_DECIMALS)
        lon = round(loc.get_property("longitude"), COORD_DECIMALS)
        clue.get_client().call_stop_sync(None)
        return f"{lat},{lon}"
    except Exception as exc:
        # The usual cause is no GeoClue agent running, which shows up here as
        # a D-Bus timeout — see the setup notes at the top.
        warn("GeoClue failed; falling back to IP geolocation", exc)
        return None


def get_city(location):
    """Reverse-geocode 'lat,lon' to a city name, or None on any failure.

    wttr.in's own `nearest_area` is a nearest-POI lookup rather than a city
    lookup: it answers "North Point Public Housing" for one 0.01-degree cell
    and "San Francisco" for the cell next door, so the label flapped on every
    refresh as the fix wandered a kilometre or two. Nominatim answers with the
    enclosing administrative area, which is stable across that whole range.
    """
    try:
        lat, lon = location.split(",")
        response = requests.get(
            "https://nominatim.openstreetmap.org/reverse",
            params={"lat": lat, "lon": lon, "format": "json", "zoom": 10},
            # Nominatim's usage policy wants an identifying User-Agent and no
            # more than 1 request/second. This module refreshes every 300s.
            headers={"User-Agent": "waybar-wttr/1.0 (personal waybar weather module)"},
            timeout=5,
        )
        response.raise_for_status()
        address = response.json().get("address", {})
        for key in ("city", "town", "village", "municipality", "county"):
            if address.get(key):
                return address[key]
        warn(f"No city in reverse geocode for {location}; using wttr.in's area name")
    except Exception as exc:
        warn("Reverse geocode failed; using wttr.in's area name", exc)
    return None


location = get_location()
url = f"https://wttr.in/{location}?format=j1" if location else "https://wttr.in?format=j1"
weather = requests.get(url).json()

# Fall back to wttr.in's own answer if the geocode fails, so a Nominatim
# outage costs us label quality rather than the whole module.
city = (get_city(location) if location else None) \
    or weather["nearest_area"][0]["areaName"][0]["value"]


def format_time(time):
    return time.replace("00", "").zfill(2)


def format_temp(temp):
    return (hour['FeelsLikeF']+"°").ljust(3)


def format_chances(hour):
    chances = {
        "chanceoffog": "Fog",
        "chanceoffrost": "Frost",
        "chanceofovercast": "Overcast",
        "chanceofrain": "Rain",
        "chanceofsnow": "Snow",
        "chanceofsunshine": "Sunshine",
        "chanceofthunder": "Thunder",
        "chanceofwindy": "Wind"
    }

    conditions = []
    for event in chances.keys():
        if int(hour[event]) > 0:
            conditions.append(chances[event]+" "+hour[event]+"%")
    return ", ".join(conditions)


data['text'] = WEATHER_CODES[weather['current_condition'][0]['weatherCode']] + \
    " " + weather['current_condition'][0]['FeelsLikeF']+ "° " + city
#data['text'] = weather['current_condition'][0]['FeelsLikeF']+"°"

data['tooltip'] = f"<b>{weather['current_condition'][0]['weatherDesc'][0]['value']} {weather['current_condition'][0]['temp_F']}°</b>\n"
data['tooltip'] += f"Feels like: {weather['current_condition'][0]['FeelsLikeF']}°\n"
data['tooltip'] += f"Wind: {weather['current_condition'][0]['windspeedKmph']}Km/h\n"
data['tooltip'] += f"Humidity: {weather['current_condition'][0]['humidity']}%\n"
for i, day in enumerate(weather['weather']):
    data['tooltip'] += f"\n<b>"
    if i == 0:
        data['tooltip'] += "Today, "
    if i == 1:
        data['tooltip'] += "Tomorrow, "
    data['tooltip'] += f"{day['date']}</b>\n"
    data['tooltip'] += f"⬆️ {day['maxtempF']}° ⬇️ {day['mintempF']}° "
    data['tooltip'] += f" {day['astronomy'][0]['sunrise']}  {day['astronomy'][0]['sunset']}\n"
    for hour in day['hourly']:
        if i == 0:
            if int(format_time(hour['time'])) < datetime.now().hour-2:
                continue
        data['tooltip'] += f"{format_time(hour['time'])} {WEATHER_CODES[hour['weatherCode']]} {format_temp(hour['FeelsLikeF'])} {hour['weatherDesc'][0]['value']}, {format_chances(hour)}\n"

# Put any degradation at the top of the tooltip, so a wrong-looking city is
# one hover away from its explanation rather than a log dive. Escaped because
# waybar renders the tooltip as Pango markup.
if warnings:
    banner = "".join(f"⚠️ {html.escape(w, quote=False)}\n" for w in warnings)
    data['tooltip'] = banner + "\n" + data['tooltip']

print(json.dumps(data))
