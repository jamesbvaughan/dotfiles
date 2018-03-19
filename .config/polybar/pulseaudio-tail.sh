#!/bin/sh

sink=$(pamixer --list-sinks | tail -n 1 | sed -E 's/([0-9]+) .*/\1/')

volume_up() {
    pactl set-sink-volume $sink +1%
}

volume_down() {
    pactl set-sink-volume $sink -1%
}

volume_mute() {
    pactl set-sink-mute $sink toggle
}

volume_print() {
    muted=$(pamixer --sink $sink --get-mute)

    if [ "$muted" = true ]; then
        echo " --%"
    else
        volume=$(pamixer --sink $sink --get-volume)

        if [ "$volume" -lt 50 ]; then
            echo " $volume%"
        else
            echo " $volume%"
        fi
    fi
}

listen() {
    volume_print

    pactl subscribe | while read -r event; do
        if echo "$event" | grep -q "#$sink"; then
            volume_print
        fi
    done
}

case "$1" in
    --up)
        volume_up
        ;;
    --down)
        volume_down
        ;;
    --mute)
        volume_mute
        ;;
    *)
        listen
        ;;
esac
