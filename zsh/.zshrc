# Oh My Zsh things
export ZSH="$HOME/.oh-my-zsh"
plugins=(fzf)
source $ZSH/oh-my-zsh.sh


# Source config in other files

## FZF config
source ~/.config/zsh/fzf.zsh

## Setup aliases
source ~/.config/zsh/aliases.zsh

## Machine-specific config, if present
EXTRA_CONFIG=$HOME/.zshrc.extra ; [ -f $EXTRA_CONFIG ] && source $EXTRA_CONFIG


# Include completions from homebrew packages
HOMEBREW_PREFIX=$(brew --prefix)
fpath+=$HOMEBREW_PREFIX/share/zsh/site-functions


# Tool-specific config

## GPG
export GPG_TTY=$(tty)

## Ruby
eval "$(rbenv init -)"

## JavaScript
eval "$(nodenv init -)"
export PATH="$(yarn global bin):$PATH"

## Go
export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$PATH"

## Flutter
export PATH="$HOME/code/flutter/bin:$PATH"

## Python (brew symlinks)
export PATH="$HOMEBREW_PREFIX/opt/python@3.9/libexec/bin:$PATH"

## GNU coreutils
export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman:$MANPATH"

## Neovim
export EDITOR='nvim'

## Personal scripts
export PATH="$HOME/.bin:$PATH"


# Remove duplicate entries in $PATH
typeset -aU path


# Configure prompt
eval "$(starship init zsh)"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
