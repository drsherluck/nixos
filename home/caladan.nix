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
    ./hyprland
    ./obsidian
  ];

  programs = {
    git.settings.user.email = "danilo@tracefy.com";
    uv.enable = true;
  };

  programs.claude-code = {
    enable = true;
  };

  home.packages = with pkgs; [
    chromium-personal
    # claude sandbox
    bubblewrap
    socat
    jellyfin-mpv-shim
  ];


  xdg.configFile."gobar/config.toml".source = (pkgs.formats.toml {}).generate "config.toml" {
    modules = ["network" "volume" "cputemp" "memory" "weather" "battery" "time"];
    network = {
      interface = "wlp99s0";
    };
  };
}
