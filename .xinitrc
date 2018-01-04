# James' startup file

# Make GTK apps look better on HiDPI displays
# export GDK_SCALE=2
export GDK_DPI_SCALE=1.5

# Start KDE Connect
/usr/lib/kdeconnectd &

# Load up some keybindings
xbindkeys --file ~/.xbindkeysrc

# Disable the system beep
xset -b

# Set the delay before and the speed of keypress repetition
xset r rate 250 25

# Start the notification service dunst
dunst &

# Set the desktop wallpaper
~/.fehbg &

# Start redshift
pgrep redshift &> /dev/null || redshift &> /dev/null &

# Load the Xresource settings
xrdb ~/.Xresources

# Start the screen locker
xautolock -detectsleep -locker lock.sh &

# Start the compositor
compton --daemon --no-fading-openclose

# Start the rxvt-unicode terminal daemon
urxvtd --quiet --opendisplay --fork

# Enable natural scrolling
xinput --set-prop 'SynPS/2 Synaptics TouchPad' \
                  'libinput Natural Scrolling Enabled' 1

# Finally, start the window manager!
exec xmonad

# vim: ft=sh:
