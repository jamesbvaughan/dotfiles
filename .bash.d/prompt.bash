source $BASH_DIR/git-prompt.sh

PROMPT_COMMAND=_prompt_command

_prompt_command() {
  echo -en "\033]0;$(dirs)\007" # sets the window title to current directory

  local EXIT="$?"

  local ResetStyle='\[\e[0m\]'
  local Bold='\[\e[1m\]'

  local Red='\[\e[31m\]'
  local Green='\[\e[32m\]'
  local Yellow='\[\e[33m\]'
  local Blue='\[\e[34m\]'
  local Purple='\[\e[35m\]'
  local Cyan='\[\e[36m\]'

  if [ $EXIT != 0 ]; then
      local PREFIX="${Red}✗"
  else
      local PREFIX="${Green}➜"
  fi

  __git_ps1 "${Bold}$PREFIX ${Blue}\W${Cyan}" "${ResetStyle} "
}
