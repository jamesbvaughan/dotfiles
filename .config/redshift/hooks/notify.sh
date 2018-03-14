#!/bin/sh

case $1 in
  period-change)
    exec notify-send "Redshift" "Period changed to $3"
esac
