source ~/.git-prompt.sh

PROMPT_COMMAND=_prompt_command

_prompt_command() {
  local EXIT="$?"

  local RCol='\[\e[00m\]'

  local Red='\[\e[31m\]'
  local Gre='\[\e[32m\]'
  local Yel='\[\e[33m\]'
  local Blu='\[\e[34m\]'
  local Cya='\[\e[36m\]'
  local Pur='\[\e[35m\]'

  if [ $EXIT != 0 ]; then
      local PREFIX="${Red}✗"
  else
      local PREFIX="${Gre}➜"
  fi

  __git_ps1 "$PREFIX ${Blu}\W${Cya}" "\[\e[00m\] "
}
