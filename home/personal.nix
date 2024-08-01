{config, ...}: {
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

  programs.git = {
    userName = "drsherluck";
    includes = [
      {path = config.sops.secrets."git/email".path;}
    ];
  };
}
