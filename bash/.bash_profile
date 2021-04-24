#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
