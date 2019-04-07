# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export GOPATH=~/go
export PATH="$HOME/.bin:$GOPATH/bin:$HOME/.yarn/bin:$HOME/.npm-global/bin:$HOME/.gem/ruby/2.5.0/bin:$HOME/.local/bin:$PATH"
export EDITOR=nvim
export HISTCONTROL=erasedups
export HISTFILESIZE=20000
export HISTSIZE=10000
export BASH_DIR=~/.bash.d
export PG_OF_PATH=/home/james/Downloads/of_v0.10.1_linux64gcc6_release
export OF_ROOT=/home/james/Downloads/of_v0.10.1_linux64gcc6_release

shopt -s autocd
shopt -s checkwinsize
shopt -s globstar
shopt -s histappend

source $BASH_DIR/aliases.bash
source $BASH_DIR/beets.bash
source $BASH_DIR/fzf.bash
source $BASH_DIR/prompt.bash
source $BASH_DIR/colored-man-pages.bash
source $BASH_DIR/tmuxinator.bash
[ -f /usr/share/doc/pkgfile/command-not-found.bash ] && \
  source /usr/share/doc/pkgfile/command-not-found.bash
[ -f /usr/share/bash-completion/bash_completion ] && \
  source /usr/share/bash-completion/bash_completion
[ -f ~/.cargo/env ] && \
  source ~/.cargo/env

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
