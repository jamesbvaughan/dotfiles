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
#          You should see "Description: WiFi" and accuracy in the tens of
#          meters. If it still says "GeoIP (ichnaea)" with km-scale
#          accuracy, the WiFi source isn't reaching Google — check that
#          NetworkManager is the active WiFi manager (not bare iwd) and
#          that geoclue's logs (`journalctl -u geoclue`) don't show
#          "WiFi scan failed".
#     Positon (`https://api.positon.xyz/v1/geolocate?key=...`, free key
#     inline in geoclue.conf) is a no-signup alternative with worse
#     coverage than Google but better than beacondb — worth trying first
#     if you'd rather skip the Google Cloud setup.
#   - No allowlist entry is required under sway: with no GeoClue agent
#     running, the daemon grants access to bus clients by default. If a
#     future setup ever denies access, add this block to
#     /etc/geoclue/geoclue.conf (the app_id must match the string passed
#     to Geoclue.Simple.new_sync below):
#       [wttr]
#       allowed=true
#       system=false

import json
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
            if best[0].get_property("accuracy") < 500:
                loop.quit()

        clue.connect("notify::location", on_notify)

        if best[0].get_property("accuracy") >= 500:
            GLib.timeout_add(5000, lambda: loop.quit() or False)
            loop.run()

        loc = best[0]
        result = f"{loc.get_property('latitude')},{loc.get_property('longitude')}"
        clue.get_client().call_stop_sync(None)
        return result
    except Exception:
        return None


location = get_location()
url = f"https://wttr.in/{location}?format=j1" if location else "https://wttr.in?format=j1"
weather = requests.get(url).json()


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
    " " + weather['current_condition'][0]['FeelsLikeF']+ "° " + weather["nearest_area"][0]["areaName"][0]["value"]
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


print(json.dumps(data))
