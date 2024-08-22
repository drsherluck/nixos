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
    kubectl
    tenv
    fluxcd
  ];

  xdg.configFile."gobar/config.toml".source = (pkgs.formats.toml {}).generate "config.toml" {
    modules = ["network" "volume" "cputemp" "memory" "weather" "battery" "time"];
    network = {
      interface = "wlp4s0";
    };
  };

  services.autorandr-rs = pkgs.lib.mkForce {
    enable = true;
    enableNotifications = true;
    config = {
      monitor = {
        eDP = {};
        HDMI-A-0 = {
          product = "V277U";
          serial = "TDCEE001852B";
        };
        DVI-D-0 = {
          product = "ZOWIE XL LCD";
          serial = "D7H05227SL0";
        };
      };
      layout.default.config = {
        eDP = {
          width = 1920;
          height = 1080;
          x = 0;
          y = 0;
          primary = true;
        };
      };
      layout.dual.config = {
        eDP = {
          width = 1920;
          height = 1080;
          x = 0;
          y = 0;
        };
        HDMI-A-0 = {
          width = 2560;
          height = 1440;
          x = 1920;
          y = 0;
          primary = true;
        };
      };
      layout.docked.config = {
        HDMI-A-0 = {
          width = 2560;
          height = 1440;
          x = 0;
          y = 0;
          primary = true;
        };
      };
    };
  };
}
