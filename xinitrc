eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

[[ -f ~/.xbindkeysrc ]] && xbindkeys
[[ -f ~/.Xmodmap     ]] && xmodmap ~/.Xmodmap
[[ -f ~/.Xresources  ]] && xrdb -merge ~/.Xresources
urxvtd -q -f -o
xset r rate 250 25
xinput --set-prop 15 'libinput Natural Scrolling Enabled' 1
xinput --set-prop 15 'libinput Horizonal Scroll Enabled' 0
feh --bg-scale ~/junk/draculamanda.png
dunst
nm-applet
trayer --edge top --align right --margin 2 --widthtype request --height 18 --transparent true --alpha 255

exec xmonad
