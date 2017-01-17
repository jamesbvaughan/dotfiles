eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

xbindkeys
xmodmap   ~/.Xmodmap
xset      r rate 250 25
dunst     &
nm-applet &
xrdb      -merge ~/.Xresources
xautolock -locker lock.sh &
feh       --bg-scale ~/Wallpapers/tram.jpg
compton   --daemon
urxvtd    --quiet --opendisplay --fork
trayer    --edge top --align right --margin 2 --widthtype request --height 22 \
          --transparent true --alpha 0 --tint 0x282a36 &
xinput    --set-prop 'SynPS/2 Synaptics TouchPad' \
                     'libinput Horizonal Scroll Enabled' 0
xinput    --set-prop 'SynPS/2 Synaptics TouchPad' \
                     'libinput Natural Scrolling Enabled' 1

exec xmonad
