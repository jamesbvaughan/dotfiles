# Oh My Zsh things
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh


# Source config in other files

## FZF config
source ~/.config/zsh/fzf.zsh

## Setup aliases
source ~/.config/zsh/aliases.zsh

## Machine-specific config, if present
EXTRA_CONFIG=$HOME/.zshrc.extra ; [ -f $EXTRA_CONFIG ] && source $EXTRA_CONFIG


# Include completions from homebrew packages
if [ -x "$(command -v brew)" ]; then
  HOMEBREW_PREFIX=$(brew --prefix)
  fpath+=$HOMEBREW_PREFIX/share/zsh/site-functions

  ## Python (brew symlinks)
  export PATH="$HOMEBREW_PREFIX/opt/python@3.9/libexec/bin:$PATH"

  ## GNU coreutils
  export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
  export MANPATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnuman:$MANPATH"
fi


# Tool-specific config

## Volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

## GPG
export GPG_TTY=$(tty)

## Ruby
if [ -x "$(command -v rbenv)" ]; then
  eval "$(rbenv init -)"
fi

## JavaScript
# eval "$(nodenv init -)" # removing this while I try out volta
# export PATH="$(yarn global bin):$PATH"

## Go
export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$PATH"

## Neovim
export EDITOR='nvim'

## Personal scripts
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
if [ -s "$BUN_INSTALL/_bun" ]; then
  source "/Users/james/.bun/_bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

# rust
if [ -s "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi

export JAVA_HOME="/opt/homebrew/opt/openjdk"

# Remove duplicate entries in $PATH
typeset -aU path

eval "$(starship init zsh)"
eval "$(zoxide init zsh --cmd cd)"
eval "$(atuin init zsh)"
