# etc
alias grep="grep --color"
alias vim="nvim"
alias mutt="neomutt"
alias cdbark='cd $GOPATH/src/github.com/jamesbvaughan/bark'
alias tmux='tmux -u'
alias ber='bundle exec ruby'
alias cat='bat'
alias ls='exa --long --header'

# Git
alias gb="git branch"
alias gc="git commit"
alias gcl="git clone"
alias gcm="git checkout master"
alias gco="git checkout"
alias gd="git diff"
alias gf="git fetch"
alias gi="git init"
alias gl="git log --pretty --oneline --abbrev-commit --graph --color"
alias gp="git push origin \$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)"
alias gpl="git pull"
alias gs="git status"
alias gx="git add . && git commit -m"
alias gamp="git commit . --amend --no-edit && git push --force origin \$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)"
alias prune="git branch --merged master | grep -v master | xargs -n 1 git branch -d"
alias stash="git stash"
alias pop="git stash pop"
alias pr="hub pull-request"

function gsha() {
  local sha=`git rev-parse HEAD`
  echo $sha | tr -d "\n" | pbcopy
  echo $sha
}

function hack() {
  local branch=$(git branch | grep -v '*' | sed 's/^  //' | fzf --no-preview)
  git checkout $branch
}

function bdel() {
  local branch=$(git branch | grep -v '*' | grep -v 'master' | sed 's/^  //' | fzf --no-preview)
  git branch -D $branch
}

function merge() {
  local branch=$(git branch | grep -v '*' | grep -v 'master' | sed 's/^  //' | fzf --no-preview)
  git stash \
    && git pull \
    && git merge --no-edit $branch \
    && git push \
    && prune \
    && git stash pop
}

# NPM
alias ni="npm install"
alias nig="npm install --global"
alias nis="npm install --save"
alias nisd="npm install --save-dev"
alias ns="npm start"

# TaskWarrior
alias taw="task add +work"
alias t="task"
alias ta="task add"
alias to="taskopen"

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
