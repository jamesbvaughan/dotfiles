# oh-my-zsh

export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh


# theme

fpath+=/opt/homebrew/share/zsh/site-functions
autoload -U promptinit; promptinit
prompt pure
zstyle :prompt:pure:git:stash show yes


# machine-specific config

EXTRA_CONFIG=$HOME/.zshrc.extra ; [ -f $EXTRA_CONFIG ] && source $EXTRA_CONFIG


export BASH_DIR=~/.bash.d
source $BASH_DIR/aliases.bash

eval "$(rbenv init -)"
eval "$(nodenv init -)"

typeset -aU path

export EDITOR='nvim'

export GOPATH=$HOME/go

export PATH="$HOME/.bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$HOME/code/flutter/bin:$PATH"
export PATH="$(yarn global bin):$PATH"

export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
