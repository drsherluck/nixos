{pkgs, ...}: let
  chromium-work = pkgs.writeShellScriptBin "chromium-work" ''
    mkdir -p "''$HOME/work/.chromium"
    chromium --user-data-dir="''$HOME/work/.chromium"
  '';
in {
  imports = [
    ./cloud.nix
    ./core.nix
    ./dev.nix
    ./i3
    ./sops
    ./sway
  ];

  # sops.secrets."git/email" = {};
  # sops.defaultSopsFile = ../secrets/arrakis.yaml;

  home.packages = [
    chromium-work
  ];

  programs = {
    git.settings.user.email = "danilobett@gmail.com";
  };

  xdg.configFile."gobar/config.toml".source = (pkgs.formats.toml {}).generate "config.toml" {
    modules = ["network" "volume" "cputemp" "memory" "weather" "battery" "time"];
    network = {
      interface = "wlp0s20f3";
    };
  };
}
