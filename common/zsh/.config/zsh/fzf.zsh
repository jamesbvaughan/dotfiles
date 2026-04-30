# gruvbox
# export FZF_DEFAULT_OPTS='
#     --color=dark
#     --color=fg:-1,bg:-1,hl:#928374,fg+:-1,bg+:-1,hl+:#fb4934:
#     --color=info:#8ec07c,prompt:#fb4934,pointer:#fb4934,marker:#fb4934,spinner:#fb4934
#     --preview "bat --color=always --plain --line-range=:$FZF_PREVIEW_LINES {}"
#     --inline-info
# '

# catppuccin latte
# export FZF_DEFAULT_OPTS=" \
# --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
# --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
# --color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"

# catppuccin mocha
# export FZF_DEFAULT_OPTS=" \
# --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
# --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
# --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
#
# export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!**/.git/*" --glob "!**/node_modules/*"'

# export FZF_CTRL_T_OPTS="
#   --walker-skip .git,node_modules,target"

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker file,dir,follow,hidden
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_CTRL_R_OPTS="--preview '' --no-info"
