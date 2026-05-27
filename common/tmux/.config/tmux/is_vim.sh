#!/bin/sh
# vim-tmux-navigator: detect whether vim/nvim is running in a tmux pane.
#
# The default check (`ps -t '#{pane_tty}'`) only looks at processes whose
# controlling terminal IS the pane's tty. That breaks when the shell is run
# behind a PTY proxy such as `atuin hex` (`exec atuin pty-proxy`): the proxy
# sits on the pane tty while the real shell + nvim run on a *separate* pty, so
# nvim is never seen and navigation always falls through to tmux.
# See https://github.com/christoomey/vim-tmux-navigator/issues/460
#
# This runs on every C-h/j/k/l, so speed matters. On a busy machine `ps -ax`
# (~100ms) and `pgrep -P` (~20ms) both scan the whole process table, while
# `ps -t <tty>` is ~1ms. So we cross the pty boundary with a single `pgrep`
# to find the proxy's inner shell, then fall back to cheap `ps -t` lookups.
#
# Usage: is_vim.sh <pane_tty> <vim_pattern>
#   <pane_tty>     tmux's #{pane_tty}, e.g. /dev/ttys000
#   <vim_pattern>  a `grep -iE` pattern matching vim executables

pane_tty="$1"
vim_pattern="$2"

# A line matches when the process is not stopped/dead (state lacks T/X/Z) and
# its command matches the vim pattern -- same test the plugin uses by default.
match() { grep -iqE '^[^TXZ ]+ +'"$vim_pattern"'$'; }

# Common case: vim runs directly on the pane's own tty (plain shell, no proxy).
ps -t "$pane_tty" -o state= -o comm= 2>/dev/null | match && exit 0

# Proxy case: the process on the pane tty runs the real shell on its own pty.
# Find that child shell with one pgrep, take its tty (where nvim also lives),
# and check there. nvim's own children (LSP servers, etc.) are never walked.
roots=$(ps -o pid= -t "$pane_tty" 2>/dev/null)
[ -n "$roots" ] || exit 1
oldifs=$IFS; set -- $roots; IFS=,; roots_csv="$*"; IFS=$oldifs   # pids -> a,b,c (pgrep -P wants a list)
kids=$(pgrep -P "$roots_csv" 2>/dev/null)
[ -n "$kids" ] || exit 1
inner_ttys=$(ps -o tty= -p $kids 2>/dev/null | grep '^[a-z]')    # drop "??" (no tty)
[ -n "$inner_ttys" ] || exit 1
set --
for t in $inner_ttys; do set -- "$@" -t "$t"; done
ps "$@" -o state= -o comm= 2>/dev/null | match && exit 0

exit 1
