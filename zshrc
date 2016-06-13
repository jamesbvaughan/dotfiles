# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/
ZSH_THEME="agnoster"
DEFAULT_USER="james"
export PATH=$HOME/.npm-global/bin:$HOME/.bin:/usr/local/bin:$PATH:$HOME/.gem/ruby/2.3.0/bin
export LANG=en_US.UTF-8
export EDITOR='vim'
export SSH_KEY_PATH="~/.ssh"
[ "$TERM" = xterm ] && export TERM=xterm-256color

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(gitfast colored-man-pages colorize command-not-found sudo)

autoload edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line

# aliases
alias pingg="ping -c 3 8.8.8.8"
alias ss="ssh -X vaughan@lnxsrv.seas.ucla.edu"
alias go="cd ~/projects/hangout"
alias vim="nvim"
alias emacs="emacs -nw"

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

# Spotify
# alias spotify="spotify --force-device-scale-factor=1.0000001"

# Reddit Reverse Search
alias reddit="node /home/james/projects/reverse-reddit-search/app.js"

# Transfer.sh
transfer() { if [ $# -eq 0 ]; then echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; }

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
