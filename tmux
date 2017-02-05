bind j select-pane -D
bind k select-pane -U
bind h select-pane -L
bind l select-pane -R

bind | split-window -h
bind - split-window -v

bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r H resize-pane -L 5
bind -r L resize-pane -R 5

set -g default-terminal "xterm-256color"
set -g status-bg colour234
set -g status-fg colour7

setw -g mode-keys vi

set -s escape-time 0

bind-key r source-file ~/.tmux.conf \; display-message "configuration reloaded"
