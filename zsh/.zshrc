export ZSH="$HOME/.oh-my-zsh"

ENABLE_CORRECTION="true"

plugins=(
  git
  safe-paste
)

source $ZSH/oh-my-zsh.sh

# User configuration

autoload -U promptinit; promptinit
prompt pure
zstyle :prompt:pure:git:stash show yes

EXTRA_CONFIG=$HOME/.zshrc.extra ; [ -f $EXTRA_CONFIG ] && source $EXTRA_CONFIG

export BASH_DIR=~/.bash.d
source $BASH_DIR/aliases.bash
source $BASH_DIR/fzf.zsh

typeset -aU path

export EDITOR='nvim'
