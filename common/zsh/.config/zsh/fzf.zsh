export FZF_DEFAULT_OPTS='
    --color=dark
    --color=fg:-1,bg:-1,hl:#928374,fg+:-1,bg+:-1,hl+:#fb4934:
    --color=info:#8ec07c,prompt:#fb4934,pointer:#fb4934,marker:#fb4934,spinner:#fb4934
    --preview "bat --color=always --plain --line-range=:$FZF_PREVIEW_LINES {}"
    --inline-info
'

export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!**/.git/*" --glob "!**/node_modules/*"'

export FZF_CTRL_R_OPTS="--preview '' --no-info"
