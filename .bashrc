export PATH="$HOME/.bin:$HOME/.npm-global/bin:$PATH"
export EDITOR=vim
export HISTSIZE=10000
export HISTFILESIZE=20000
export BASH_DIR=~/.bash.d

shopt -s histappend

source $BASH_DIR/aliases.bash
source $BASH_DIR/fzf.bash
source $BASH_DIR/prompt.bash
source $BASH_DIR/colored-man-pages.bash
