xrdb .Xresources

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

if [ -s ~/.Xmodmap ]; then
    xmodmap ~/.Xmodmap
fi

/* i3 */
exec i3

/* budgie */
/* export XDG_CURRENT_DESKTOP=Budgie:GNOME */
/* exec budgie-desktop */

/* gnome */
/* exec gnome-session */

/* kde plasma */
/* exec startkde */
