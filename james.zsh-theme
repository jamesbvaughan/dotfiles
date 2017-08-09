green="%F{002}"
yellow="%F{003}"
blue="%F{004}"
cyan="%F{006}"
red="%F{009}"

local ret_status="%(?:$green:$red)➜"

PROMPT='$ret_status $blue%c $(git_prompt_info)$reset_color'

ZSH_THEME_GIT_PROMPT_PREFIX="$cyan("
ZSH_THEME_GIT_PROMPT_CLEAN=") $green✔ "
ZSH_THEME_GIT_PROMPT_DIRTY=") $yellow✗ "
ZSH_THEME_GIT_PROMPT_SUFFIX="$reset_color"
