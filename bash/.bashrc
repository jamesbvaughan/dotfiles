# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export GOPATH=~/go
export PATH="$HOME/.bin:$GOPATH/bin:$HOME/.yarn/bin:$HOME/.npm-global/bin:$HOME/.gem/ruby/2.5.0/bin:$HOME/.local/bin:$PATH"
export EDITOR=vim
export HISTCONTROL=erasedups
export HISTFILESIZE=20000
export HISTSIZE=10000
export BASH_DIR=~/.bash.d

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
[ -f /usr/share/nvm/init-nvm.sh ] && \
  source /usr/share/nvm/init-nvm.sh
[ -f ~/.cargo/env ] && \
  source ~/.cargo/env

eval "$(pandoc --bash-completion)"

trap 'echo -en "\e]0;$BASH_COMMAND\007"' DEBUG

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
