{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./tmux
    ./sway
    ./i3
    ./foot
    ./alacritty
    ./rofi
    ./starship
    ./chromium
    ./dunst
    ./zsh
    ./fastfetch
    ./neovim
    ./git
    ./sops
    ./dev.nix
    ./core.nix
    ./cloud.nix
  ];

  # sops.secrets."git/email" = {};
  # sops.defaultSopsFile = ../secrets/arrakis.yaml;

  programs = {
    git.userEmail = "danilobett@gmail.com";
  };

  xdg.configFile."gobar/config.toml".source = (pkgs.formats.toml {}).generate "config.toml" {
    modules = ["network" "volume" "cputemp" "memory" "weather" "battery" "time"];
    network = {
      interface = "wlp0s20f3";
    };
  };
}
