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

  # sops.secrets."git/email" = {};
  # sops.defaultSopsFile = ../secrets/arrakis.yaml;

  programs = {
    git.userEmail = "danilobett@gmail.com";
    awscli = {
      enable = true;
      package = pkgs.awscli2;
    };
  };

  home.packages = with pkgs; [
    tenv
  ];

  xdg.configFile."gobar/config.toml".source = (pkgs.formats.toml {}).generate "config.toml" {
    modules = ["network" "volume" "cputemp" "memory" "weather" "battery" "time"];
    network = {
      interface = "wlp0s20f3";
    };
  };
}
