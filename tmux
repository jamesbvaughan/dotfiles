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
bind-key r source-file ~/.tmux.conf \; display-message "configuration reloaded"

# statusline left
set -g status-left-length 40
set -g status-left '#[fg=colour33] #(hostname):#S '

# statusline right
set -g status-right '#(cat /sys/class/power_supply/BAT1/capacity)% '
set -ag status-right '%d/%m '
set -ag status-right '%H:%M '

# window list
setw -g window-status-format "#I:#W "

# colors
# default statusbar colors
set-option -g status-bg colour235 #base02
set-option -g status-fg colour136 #yellow
set-option -g status-attr default

# default window title colors
set-window-option -g window-status-fg colour244 #base0
set-window-option -g window-status-bg default
#set-window-option -g window-status-attr dim

# active window title colors
set-window-option -g window-status-current-fg colour166 #orange
set-window-option -g window-status-current-bg default
#set-window-option -g window-status-current-attr bright

# pane border
set-option -g pane-border-fg colour235 #base02
set-option -g pane-active-border-fg colour240 #base01

# message text
set-option -g message-bg colour235 #base02
set-option -g message-fg colour166 #orange

# pane number display
set-option -g display-panes-active-colour colour33 #blue
set-option -g display-panes-colour colour166 #orange

# clock
set-window-option -g clock-mode-colour colour64 #green
