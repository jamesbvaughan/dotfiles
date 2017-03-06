# start window numbers at 1
set -g base-index 1

# pane navigation bindings
bind j select-pane -D
bind k select-pane -U
bind h select-pane -L
bind l select-pane -R

# window splitting bindings
bind | split-window -h
bind - split-window -v

# pane resizing bindings
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r H resize-pane -L 5
bind -r L resize-pane -R 5

# fix color problems
set -g default-terminal "xterm-256color"

# vim keys
setw -g mode-keys vi

# remove escape key delay
set -s escape-time 0

# mouse support
set -g mouse-select-window on
set -g mouse-select-pane on
set -g mouse-resize-pane on
set -g mouse on

# reload configuration
bind-key r source-file ~/.tmux.conf \; display-message "configuration reloaded"

# statusline
set -g status-bg colour0
set -g status-fg colour7
set -g status-left-length 40
set -g status-left '#[fg=colour16,bg=colour4] #(hostname) '
set -ag status-left '#[fg=colour16,bg=colour12] #S '
set -g status-right '#[fg=colour16,bg=colour11,bold] #(battery)% '
set -ag status-right '#[fg=colour16,bg=colour12,bold] %d/%m'
set -ag status-right ' #[fg=colour16,bg=colour4,bold] %H:%M '

# window list
setw -g window-status-format "#[bg=colour0,fg=colour8] #I:#W "
setw -g window-status-current-format "#[fg=colour12,bg=colour0] #I:#W "

