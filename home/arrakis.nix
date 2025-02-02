{
  config,
  pkgs,
  ...
}: let
  chromium-work = pkgs.writeShellScriptBin "chromium-work" ''
    mkdir -p "''$HOME/work/.chromium"
    chromium --user-data-dir="''$HOME/work/.chromium"
  '';
in {
  imports = [
    ./cloud.nix
    ./core.nix
    ./dev.nix
    ./foot
    ./i3
    ./sops
    ./sway
  ];

  sops.secrets."git/email" = {};
  sops.defaultSopsFile = ../secrets/arrakis.yaml;

  programs = {
    git.includes = [
      {path = config.sops.secrets."git/email".path;}
    ];
  };

  home.packages = [
    chromium-work
  ];

  xdg.configFile."gobar/config.toml".source = (pkgs.formats.toml {}).generate "config.toml" {
    modules = ["network" "volume" "cputemp" "memory" "weather" "time"];
    network = {
      interface = "enp4s0";
    };
  };
}
