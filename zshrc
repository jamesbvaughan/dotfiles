# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

DEFAULT_USER="james"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git colored-man-pages colorize command-not-found cp sudo)

# User configuration

export PATH=$HOME/.npm-global/bin:$HOME/.bin:/usr/local/bin:$PATH:$HOME/software/webstorm/bin

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# preferred editor
export EDITOR='vim'

# ssh
export SSH_KEY_PATH="~/.ssh"

autoload edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line

# aliases
alias pingg="ping -c 3 8.8.8.8"
alias ss="ssh -X vaughan@lnxsrv.seas.ucla.edu"
alias go="cd ~/projects/hangout"

# Web searches
alias sa="s -p amazon"
alias sr="s -p reddit"
alias sc="s -p soundcloud"
alias sw="s -p wikipedia"
alias syt="s -p youtube"

# Git
alias gs="git status"
alias gc="git commit"
alias gcm="git commit -m"
alias gp="git push"
alias gx="git add . && git commit -m"

# Npm
alias ni="npm install"
alias nig="npm install -g"
alias nis="npm install --save"
alias ns="npm start"

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/base16-default.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

ZSH_CACHE_DIR=$HOME/.oh-my-zsh-cache
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

# Android
ANDROID_HOME=/home/james/Android/Sdk

source $ZSH/oh-my-zsh.sh
