{
  config,
  pkgs,
  ...
}: let
  chromium-personal = pkgs.writeShellScriptBin "chromium-personal" ''
    mkdir -p "''$HOME/personal/.chromium"
    chromium --user-data-dir="''$HOME/personal/.chromium"
  '';
in {
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

  sops.defaultSopsFile = ../secrets/caladan.yaml;
  sops.validateSopsFiles = false;

  sops.secrets.git_email = {};
  sops.secrets.github_token = {
    sopsFile = "${config.home.homeDirectory}/.sops/secrets/secrets.yaml";
  };

  home.packages = [
    pkgs.mycli
    chromium-personal
  ];

  programs = {
    git.includes = [
      {path = config.sops.secrets.git_email.path;}
    ];
    gh.enable = true;
    zsh.envExtra = ''
      export GITHUB_TOKEN="$(cat ${config.sops.secrets.github_token.path})"
    '';
  };

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
        Work-HDMI-0 = {
          product = "PL2730Q";
          serial = "1153890121602";
        };
        Work-DisplayPort-0 = {
          product = "PL2730Q";
          serial = "1153895021478";
        };
        Work-HDMI-1 = {
          product = "PL2730Q";
          serial = "1153895021477";
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
      layout.work_0.config = {
        eDP = {
          width = 1920;
          height = 1080;
          x = 1280;
          y = 1440;
        };
        Work-DisplayPort-0 = {
          width = 2560;
          height = 1440;
          x = 0;
          y = 0;
        };
        Work-HDMI-0 = {
          width = 2560;
          height = 1440;
          x = 2560;
          y = 0;
          primary = true;
        };
      };
      layout.work_1.config = {
        eDP = {
          width = 1920;
          height = 1080;
          x = 2560;
          y = 0;
          primary = true;
        };
        Work-HDMI-1 = {
          width = 2560;
          height = 1440;
          x = 0;
          y = 0;
        };
      };
      layout.work_2.config = {
        eDP = {
          width = 1920;
          height = 1080;
          x = 2560;
          y = 0;
          primary = true;
        };
        Work-DisplayPort-0 = {
          width = 2560;
          height = 1440;
          x = 0;
          y = 0;
        };
      };
    };
  };
}
