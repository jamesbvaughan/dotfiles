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

  # Comment and uncomment below for the light theme.

  # Solarized Dark color scheme for fzf
  local colors="
    --color fg:-1,bg:-1,hl:$blue,fg+:$base2,bg+:$base02,hl+:$blue
    --color info:$yellow,prompt:$yellow,pointer:$base3,marker:$base3,spinner:$yellow
  "
  local other_options='
    --preview "bat --color=always --style=snip --line-range :100 {}"
    --inline-info
  '
  export FZF_DEFAULT_OPTS="$colors $other_options"
}
_gen_fzf_default_opts
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!**/.git/*" --glob "!**/node_modules/*"'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
