# start window numbers at 1
set -g base-index 1

# pane navigation bindings
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
bind -n M-h select-pane -L
bind -n M-j select-pane -D
bind -n M-k select-pane -U
bind -n M-l select-pane -R

# window switching bindings
bind -n M-n next-window
bind -n M-p previous-window

# window splitting bindings
bind | split-window -h
bind - split-window -v

# pane resizing bindings
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r H resize-pane -L 5
bind -r L resize-pane -R 5

# fix color problems
set -g default-terminal "screen-256color"

# don't rename windows for me
set-option -g allow-rename off

# vim keys
setw -g mode-keys vi

# remove escape key delay
set -s escape-time 0

# mouse support
set -gq mouse-select-window on
set -gq mouse-select-pane on
set -gq mouse-resize-pane on
set -gq mouse on

# reload configuration
bind-key r source-file ~/.tmux.conf

# statusline left
set -g status-left-length 100
set -g status-left '#[bg=colour6] #h '
set -ag status-left '#[bg=default] '
set -ag status-left '#[bg=colour1] #S '
set -ag status-left '#[bg=default] '

# statusline right
set -g status-right-length 100
set -g status-right '#[bg=colour5] %A %H:%M '
set -ag status-right '#[bg=default] '
set -ag status-right '#[bg=colour13] #I '

# window list
set-window-option -g window-status-bg colour4
set-window-option -g window-status-current-bg colour2
set-window-option -g window-status-current-format ' #W '
setw -g window-status-format " #W "
set -g status-justify centre
set-option -g status-position top

# colors
# default statusbar colors
set-option -g status-bg colour8
set-option -g status-fg colour8

# pane border
set-option -g pane-border-fg colour4
set-option -g pane-active-border-fg colour2

# message text
set-option -g message-bg colour8
set-option -g message-fg colour9
