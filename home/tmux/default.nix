{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    plugins = with pkgs; [tmuxPlugins.yank];
    package = pkgs.tmux;
    extraConfig = ''
      unbind C-b
      set -g prefix C-space

      unbind c
      bind c new-window -c '#{pane_current_path}'
      unbind %
      bind % split-window -h -c '#{pane_current_path}'
      unbind '"'
      bind '"' split-window -v -c '#{pane_current_path}'

      unbind h
      bind h select-pane -L
      unbind j
      bind j select-pane -D
      unbind k
      bind k select-pane -U
      unbind l # normally used for last-window
      bind l select-pane -R

      unbind Left
      bind -r Left resize-pane -L 5
      unbind Right
      bind -r Right resize-pane -R 5
      unbind Down
      bind -r Down resize-pane -D 5
      unbind Up
      bind -r Up resize-pane -U 5

      set -w -g main-pane-width 85
      # set -g status-bg '#0f0f14'
      set -g status-fg '#e6e1cf'
      set -g status-left-length 40
      set -g status-position bottom
      set -g status-left '#[fg=#55efc4] #S '
      set -g status-right "#[fg=#3e4b59]$USER@#h #[fg=#e6e1cf]%l:%M %p"
      set -g status-interval 60
      set -g set-titles-string "#T : #h > #S > #W"

      set -g base-index 1
      set -g history-limit 65536
      set -g pane-base-index 1
      set -g renumber-windows on
      set -g mouse on
      set -s escape-time 0
      set -g set-titles on
      set -g focus-events on
      set -w -g automatic-rename off
      set -w -g wrap-search off
    '';
  };
}
