# My personal settings
# ---------
_gen_fzf_default_opts() {
  local base03="234"
  local base02="235"
  local base01="240"
  local base00="241"
  local base0="244"
  local base1="245"
  local base2="254"
  local base3="230"
  local yellow="136"
  local orange="166"
  local red="160"
  local magenta="125"
  local violet="61"
  local blue="33"
  local cyan="37"
  local green="64"

  local colors="
    --color fg:-1,bg:-1,hl:$blue,fg+:$base2,bg+:$base02,hl+:$blue
    --color info:$yellow,prompt:$yellow,pointer:$base3,marker:$base3,spinner:$yellow
  "
  local other_options='
    --preview "[[ $(file --mime {}) =~ binary ]] &&
                 echo {} is a binary file ||
                 (highlight -O ansi {} ||
                 cat {}) 2> /dev/null | head -$LINES"
    --inline-info
  '
  export FZF_DEFAULT_OPTS="$colors $other_options"
}
_gen_fzf_default_opts
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!**/.git/*" --glob "!**/node_modules/*"'

export FZF_CTRL_R_OPTS="--preview '' --no-info"


# Setup fzf
# ---------
local fzf_dir
if [ -d '/usr/local/opt/fzf' ]; then
  fzf_dir='/usr/local/opt/fzf'
elif [ -d '/usr/share/fzf' ]; then
  fzf_dir='/usr/share/fzf'
elif [ -d '/opt/homebrew/opt/fzf' ]; then
  fzf_dir='/opt/homebrew/opt/fzf'
else
  echo "Seems like fzf isn't installed!"
fi

if [[ ! "$PATH" == *$fzf_dir* ]]; then
  export PATH="${PATH:+${PATH}:}$fzf_dir/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$fzf_dir/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$fzf_dir/shell/key-bindings.zsh"
