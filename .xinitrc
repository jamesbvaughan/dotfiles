# James' startup file
export PATH="$HOME/.bin:$HOME/.yarn/bin:$HOME/.npm-global/bin:$PATH:$HOME/.gem/ruby/2.5.0/bin"

# Make GTK apps look better on HiDPI displays
# export GDK_SCALE=2
export GDK_DPI_SCALE=1.5

# Start GNOME Keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

# XDG Directories
export XDG_CONFIG_HOME=$HOME/.config

# Start the network manager applet
nm-applet &

# Start blueman
blueman-applet &

# Load up some keybindings
xbindkeys --file ~/.xbindkeysrc

# Disable the system beep
xset -b

# Set the delay before and the speed of keypress repetition
xset r rate 250 25

# Set the desktop wallpaper
~/.fehbg &

# Load the Xresource settings
xrdb ~/.Xresources

# Start the kde connect applet
kdeconnect-indicator &

# Start the Syncthing applet
syncthing-gtk --minimized &

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
