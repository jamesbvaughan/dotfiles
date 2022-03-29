# etc
alias grep="grep --color"
alias vim="nvim"
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

# NPM
alias ni="npm install"
alias nig="npm install --global"
alias nis="npm install --save"
alias nisd="npm install --save-dev"
alias ns="npm start"