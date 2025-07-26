{
  pkgs,
  lib,
  ...
}: {
  programs.swaylock.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    swaynag.enable = true;
    config = null;
    extraConfig = builtins.readFile ./config;
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export NIXOS_OZONE_WL="1"
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    '';
  };

  home.packages = with pkgs; [
    wl-clipboard
    kdePackages.xwaylandvideobridge
  ];

  services.kanshi = {
    enable = true;
    settings = lib.mkDefault [
      {
        profile.name = "default";
        profile.outputs = [
          {
            criteria = "eDP-1";
            scale = 2.0;
          }
        ];
      }
    ];
  };
}
