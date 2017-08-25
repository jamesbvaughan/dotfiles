local ret_status="%(?:%{$fg[green]%}➜:%{$fg_bold[red]%}✗%b)"
PROMPT='${ret_status} %{$fg[blue]%}%c $(git_prompt_info)% %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_CLEAN=") %{$fg[green]%}✔ "
ZSH_THEME_GIT_PROMPT_DIRTY=") %{$fg[yellow]%}✗ "
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

# vim: set ft=zsh:
