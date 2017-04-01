# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh
export FZF_DEFAULT_COMMAND='ag -g "" --ignore node_modules'
export HOMEBREW_GITHUB_API_TOKEN=9e51d435081597018249134b38a9003cf7eda160
export LANG=en_US.utf8
export RUBYPATH="$HOME/.rvm/gems/ruby-2.4.0/bin"
export PATH="$RUBYPATH:/usr/local/bin:$HOME/.bin:$PATH"
export TERM=xterm-256color
DEFAULT_USER="james"
ENABLE_CORRECTION="true"
ZSH_THEME="dracula"

plugins=(docker gitfast colored-man-pages colorize command-not-found sudo)

# aliases
alias vim="nvim"
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

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
