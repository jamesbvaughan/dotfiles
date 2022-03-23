# My ZSH config

## Configure zsh options
## See `man zshoptions` for more info on these.

### Allow changing directories without `cd`
setopt auto_cd

### Beep less when autocompleting
setopt no_list_beep

### Set the completion result immediately rather than after the second "tab"
# setopt menu_complete

### Have all sessions append to the same history file
setopt append_history


## Use common emacs/readline keybindings
bindkey -e


## Include completions from homebrew packages
fpath+=/opt/homebrew/share/zsh/site-functions


## Machine-specific config
EXTRA_CONFIG=$HOME/.zshrc.extra ; [ -f $EXTRA_CONFIG ] && source $EXTRA_CONFIG


## Setup aliases
source ~/.aliases.zsh


## Ignore duplicate entries in $PATH
typeset -aU path


## Tool-specific config

### Ruby
eval "$(rbenv init -)"

### JavaScript
eval "$(nodenv init -)"
export PATH="$(yarn global bin):$PATH"

### Go
export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$PATH"

### Flutter
export PATH="$HOME/code/flutter/bin:$PATH"

### GNU coreutils
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"

### Neovim
export EDITOR='nvim'

### Personal scripts
export PATH="$HOME/.bin:$PATH"

### FZF
source ~/.fzf.zsh


## Configure prompt
eval "$(starship init zsh)"
