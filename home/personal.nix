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
  sops.defaultSopsFile = ../secrets/arrakis.yaml;

  programs = {
    git.includes = [
      {path = config.sops.secrets."git/email".path;}
    ];
    awscli = {
      enable = true;
      package = pkgs.awscli2;
    };
  };

  home.packages = with pkgs; [
    tenv
  ];

  xdg.configFile."gobar/config.toml".source = (pkgs.formats.toml {}).generate "config.toml" {
    modules = ["network" "volume" "cputemp" "memory" "weather" "time"];
    network = {
      interface = "enp4s0";
    };
  };
}
