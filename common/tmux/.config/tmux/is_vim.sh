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
# Instead, walk the process tree starting from whatever sits on the pane tty
# and follow parent->child links (which cross the pty boundary), then apply the
# same state + name match the plugin uses on the whole subtree.
#
# Usage: is_vim.sh <pane_tty> <vim_pattern>
#   <pane_tty>     tmux's #{pane_tty}, e.g. /dev/ttys000
#   <vim_pattern>  a `grep -iE` pattern matching vim executables

pane_tty="$1"
vim_pattern="$2"

ps -axo pid=,ppid=,tty=,state=,comm= | awk -v tty="$pane_tty" '
  BEGIN { sub(/^\/dev\//, "", tty) }  # /dev/ttys000 -> ttys000, /dev/pts/0 -> pts/0
  {
    pid = $1; ppid = $2; t = $3; state = $4
    comm = $5; for (i = 6; i <= NF; i++) comm = comm " " $i
    STATE[pid] = state; COMM[pid] = comm
    KIDS[ppid] = KIDS[ppid] " " pid
    if (t == tty) roots[pid] = 1     # processes directly on the pane tty
  }
  END {
    n = 0
    for (p in roots) { queue[n++] = p; seen[p] = 1 }
    for (i = 0; i < n; i++) {        # breadth-first over the subtree
      p = queue[i]
      if (p in STATE) print STATE[p], COMM[p]
      m = split(KIDS[p], kids, " ")
      for (j = 1; j <= m; j++) {
        c = kids[j]
        if (c != "" && !(c in seen)) { seen[c] = 1; queue[n++] = c }
      }
    }
  }
' | grep -iqE '^[^TXZ ]+ +'"$vim_pattern"'$'
