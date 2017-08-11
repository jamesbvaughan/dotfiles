export ZSH=~/.oh-my-zsh
export FZF_DEFAULT_COMMAND='ag -g "" --ignore node_modules'
export FZF_DEFAULT_OPTS='
  --color dark,hl:33,hl+:37,fg+:235,bg+:136,fg+:254
  --color info:254,prompt:37,spinner:108,pointer:235,marker:235
'
DEFAULT_USER="james"
ENABLE_CORRECTION="true"
ZSH_THEME="james"

plugins=(gitfast colored-man-pages colorize sudo)

alias ag="ag --ignore node_modules"

alias gc="git commit"
alias gcm="git commit -m"
alias gi="git init"
alias gp="git push"
alias gs="git status"
alias gx="git add . && git commit -m"

alias ni="npm install"
alias nig="npm install --global"
alias nis="npm install --save"
alias nisd="npm install --save-dev"
alias ns="npm start"

MY_PATH="$HOME/.bin"
NPM_PATH="$HOME/.npm-global/bin"
export PATH="$MY_PATH:$NPM_PATH:$PATH"

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
