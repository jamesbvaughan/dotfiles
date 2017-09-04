export PATH="$HOME/.bin:$HOME/.npm-global/bin:$PATH"
export FZF_DEFAULT_COMMAND='ag -g "" --ignore node_modules'
export FZF_DEFAULT_OPTS='
  --color dark,hl:33,hl+:37,fg+:235,bg+:136,fg+:254
  --color info:254,prompt:37,spinner:108,pointer:235,marker:235
'
export EDITOR="vim"
export HISTSIZE=10000
export HISTFILESIZE=20000

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

shopt -s histappend

source ~/.fzf.bash
source ~/.james-prompt.bash
