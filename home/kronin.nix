{pkgs, ...}: {
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

  xdg.configFile."gobar/config.toml".source = (pkgs.formats.toml {}).generate "config.toml" {
    modules = ["network" "volume" "cputemp" "memory" "weather" "battery" "time"];
    network = {
      interface = "wlp0s20f3";
    };
  };
}
