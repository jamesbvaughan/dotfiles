# Install and set up zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Load starship theme
# line 1: `starship` binary as command, from github release
# line 2: starship setup at clone(create init.zsh, completion)
# line 3: pull behavior same as clone, source init.zsh
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

# Use emacs-syntax keybindings
bindkey -e

# Zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit pack"default+keys" for fzf
zinit light atuinsh/atuin
zinit light asdf-vm/asdf

# History options
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt append_history
setopt share_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Make ctrl-p and ctrl-n cycle through history
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Completion colors
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}


autoload -U compinit && compinit

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

## bun
export BUN_INSTALL="$HOME/.bun"
if [ -s "$BUN_INSTALL/_bun" ]; then
  source "/Users/james/.bun/_bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

## rust
if [ -s "$HOME/.cargo/env" ]; then
  source "$HOME/.cargo/env"
fi

## Java
export JAVA_HOME="/opt/homebrew/opt/openjdk"

## PostgreSQL
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

## Personal scripts
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.bin:$PATH"


# Remove duplicate entries in $PATH
typeset -aU path

# eval "$(starship init zsh)"
eval "$(zoxide init zsh --cmd cd)"
# eval "$(atuin init zsh)"
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
