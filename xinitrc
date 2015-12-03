xrdb .Xresources

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

if [ -s ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
fi

exec i3
