#!/usr/bin/python

# Fetch and output the current temperature
import forecastio

api_key = 'f06a12c5e6ea0651f1e0742025200483'
lat = 34.0717103
lng = -118.4500963

forecast = forecastio.load_forecast(api_key, lat, lng)

current = forecast.currently()

print(str(int(current.temperature)) + '°')
