# etc
alias ls="ls --color=auto --file-type --human-readable"
alias grep="grep --color"
alias vim="vim -X"
alias mutt="neomutt"

# Git
alias gc="git commit"
alias gcm="git commit -m"
alias gi="git init"
alias gp="git push"
alias gs="git status"
alias gx="git add . && git commit -m"

# NPM
alias ni="npm install"
alias nig="npm install --global"
alias nis="npm install --save"
alias nisd="npm install --save-dev"
alias ns="npm start"

# Systemd
alias sdr="sudo systemctl daemon-reload"
alias se="sudo systemctl enable"
alias slt="sudo systemctl list-timers"
alias slu="sudo systemctl list-units"
alias sres="sudo systemctl restart"
alias sstart="sudo systemctl start"
alias sstat="sudo systemctl status"
alias sstop="sudo systemctl stop"
alias sudr="systemctl --user daemon-reload"
alias sue="systemctl --user enable"
alias sult="systemctl --user list-timers"
alias sulu="systemctl --user list-units"
alias sures="systemctl --user restart"
alias sustart="systemctl --user start"
alias sustat="systemctl --user status"
alias sustop="systemctl --user stop"
