local ret_status="%(?:%{$fg[green]%}➜ :%{$fg[red]%}✗ )"
PROMPT='%{$ret_status%} %{$fg[blue]%}%c%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=") %{$fg[green]%}✔"
ZSH_THEME_GIT_PROMPT_DIRTY=") %{$fg[yellow]%}✗"
