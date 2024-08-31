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

  sops.secrets."git/email" = {};
  sops.defaultSopsFile = ../secrets/arrakis.yaml;

  programs = {
    git.includes = [
      {path = config.sops.secrets."git/email".path;}
    ];
  };

  xdg.configFile."gobar/config.toml".source = (pkgs.formats.toml {}).generate "config.toml" {
    modules = ["network" "volume" "cputemp" "memory" "weather" "time"];
    network = {
      interface = "enp4s0";
    };
  };
}
