{pkgs, ...}: let
  chromium-personal = pkgs.writeShellScriptBin "chromium-personal" ''
    mkdir -p "''$HOME/personal/.chromium"
    chromium --user-data-dir="''$HOME/personal/.chromium"
  '';
in {
  imports = [
    ./cloud.nix
    ./core.nix
    ./dev.nix
    ./i3
    ./sway
  ];

  programs = {
    git.userEmail = "danilobett@gmail.com";
  };

  home.packages = [
    pkgs.mycli
    chromium-personal
  ];

  xdg.configFile."gobar/config.toml".source = (pkgs.formats.toml {}).generate "config.toml" {
    modules = ["network" "volume" "cputemp" "memory" "weather" "battery" "time"];
    network = {
      interface = "wlp99s0";
    };
  };
}
