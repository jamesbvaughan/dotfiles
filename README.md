# James' config files and scripts

I use [GNU Stow](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html)
to manage these.
If you want to start using any of my configurations,

1. install stow:
   - Ubuntu/Debian: `sudo apt install stow`
   - Arch: `sudo pacman -S stow`
2. clone the repo:
   - `git clone git@github.com:jamesbvaughan/dotfiles ~/.dotfiles`
   - `cd ~/.dotfiles`
3. install the desired configuration files:
   - `stow vim`
   - `stow xmonad`
   - etc.

Let me know if you have any questions or issues and I'll be happy to help!
