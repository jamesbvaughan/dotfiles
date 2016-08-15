eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

urxvtd -q -f -o
xset r rate 250 25
xinput --set-prop 15 'libinput Natural Scrolling Enabled' 1
xinput --set-prop 15 'libinput Horizonal Scroll Enabled' 0
[[ -f ~/.Xmodmap    ]] && xmodmap ~/.Xmodmap
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
feh --bg-scale ~/junk/draculamanda.png

exec xmonad
