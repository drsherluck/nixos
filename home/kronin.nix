{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./cloud.nix
    ./core.nix
    ./dev.nix
    ./foot
    ./i3
    ./sops
    ./sway
  ];

  # sops.secrets."git/email" = {};
  # sops.defaultSopsFile = ../secrets/arrakis.yaml;

  programs = {
    git.userEmail = "danilobett@gmail.com";
  };

  services.kanshi = {
    settings = lib.mkForce [
      {
        profile.name = "laptop";
        profile.outputs = [
          {
            criteria = "eDP-1";
            scale = 2.0;
          }
        ];
      }
    ];
  };

  xdg.configFile."gobar/config.toml".source = (pkgs.formats.toml {}).generate "config.toml" {
    modules = ["network" "volume" "cputemp" "memory" "weather" "battery" "time"];
    network = {
      interface = "wlp0s20f3";
    };
  };
}
