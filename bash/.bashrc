# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export GOPATH=~/go
export PATH="$HOME/.bin:$GOPATH/bin:$HOME/.yarn/bin:$HOME/.npm-global/bin:$HOME/.rbenv/shims:$HOME/.local/bin:/usr/local/opt/coreutils/libexec/gnubin:$HOME/Library/Python/3.7/bin:$PATH"
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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# heroku autocomplete setup
HEROKU_AC_BASH_SETUP_PATH=/Users/james/Library/Caches/heroku/autocomplete/bash_setup && test -f $HEROKU_AC_BASH_SETUP_PATH && source $HEROKU_AC_BASH_SETUP_PATH;

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"
