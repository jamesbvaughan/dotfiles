export ZSH=~/.oh-my-zsh
export FZF_DEFAULT_COMMAND='ag -g "" --ignore node_modules'
export PATH="$HOME/.bin:$PATH"
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

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
