# xbindkeys
# xset      r rate 250 25
# dunst     &
nm-applet &
xrdb      -merge ~/.Xresources
# xautolock -locker lock.sh &
# feh       --bg-scale ~/Wallpapers/tram.jpg
# compton   --daemon
urxvtd    --quiet --opendisplay --fork
# xinput    --set-prop 'SynPS/2 Synaptics TouchPad' \
#                      'libinput Horizonal Scroll Enabled' 0
# xinput    --set-prop 'SynPS/2 Synaptics TouchPad' \
#                      'libinput Natural Scrolling Enabled' 1

exec xmonad

# vim: ft=sh:
