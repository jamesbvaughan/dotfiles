#!/bin/sh

rofi -dmenu -i -input /usr/share/dict/words -levenshtein-sort -p "spell:" >> /dev/null
