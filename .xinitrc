# James' startup file
# This is run when the X server is started

# Make GTK apps look better on HiDPI displays
export GDK_SCALE=2
export GDK_DPI_SCALE=0.5

# Start JACK
~/.bin/start_jack.sh &

# Load up some keybindings
xbindkeys --file ~/.xbindkeysrc

# Disable the system beep
xset -b

# Set the delay before and the speed of keypress repetition
xset r rate 250 25

# Start the notification service dunst
dunst &

# Start the NetworkManager system tray applet
nm-applet &

# Set the desktop wallpaper
~/.fehbg &

# Load the Xresource settings
xrdb -merge ~/.Xresources

# Start the screen locker
xautolock -detectsleep -locker lock.sh &

# Start the compositor
compton   --daemon --fade-delta=3

# Start the rxvt-unicode terminal daemon
urxvtd    --quiet --opendisplay --fork

# Enable natural scrolling
xinput --set-prop 'SynPS/2 Synaptics TouchPad' \
                  'libinput Natural Scrolling Enabled' 1

# Finally, start the window manager!
exec xmonad

# vim: ft=sh:
