export ZSH="$HOME/.oh-my-zsh"

ENABLE_CORRECTION="true"

plugins=(
  git
  safe-paste
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Thame
autoload -U promptinit; promptinit
prompt pure
# prompt_newline='%666v'
PROMPT=" $PROMPT"
zstyle :prompt:pure:git:stash show yes

source $HOME/.zshrc.extra
source $HOME/.bash.d/aliases.bash
source $HOME/.fzf.zsh

typeset -aU path

export EDITOR='nvim'
