export ZSH="$HOME/.oh-my-zsh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completio

fpath+=('/Users/james/.nvm/versions/node/v15.5.1/lib/node_modules/pure-prompt/functions')

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
export GOPATH=$HOME/go
export PATH="$HOME/.bin:$(yarn global bin):$GOPATH/bin:/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"


eval "$(rbenv init -)"
eval "$(nodenv init -)"
