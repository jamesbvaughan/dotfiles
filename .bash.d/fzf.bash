# My personal settings
# ---------
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!node_modules/*"'
export FZF_DEFAULT_OPTS='
  --color dark,hl:33,hl+:37,fg+:235,bg+:136,fg+:254
  --color info:254,prompt:37,spinner:108,pointer:235,marker:235
  --no-bold
  --preview '"'"'[[ $(file --mime {}) =~ binary ]] &&
               echo {} is a binary file ||
               (highlight -O ansi {} ||
               cat {}) 2> /dev/null | head -100'"'"'
'

# Setup fzf
# ---------
if [[ ! "$PATH" == */home/james/.fzf/bin* ]]; then
  export PATH="$PATH:/home/james/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/james/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/james/.fzf/shell/key-bindings.bash"
