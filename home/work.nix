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
    ./dev.nix
    ./core.nix
    ./sops
  ];

  sops.secrets."git/email" = {};
  sops.defaultSopsFile = ../secrets/caladan.yaml;

  programs.git = {
    userName = "drsherluck";
    includes = [
      {path = config.sops.secrets."git/email".path;}
    ];
  };

  xdg.configFile."gobar/config.toml".source = (pkgs.formats.toml {}).generate "config.toml" {
    modules = ["network" "volume" "cputemp" "memory" "weather" "battery" "time"];
    network = {
      interface = "wlp4s0";
    };
  };
}
