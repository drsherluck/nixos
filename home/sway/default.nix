{pkgs, ...}: {
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
    settings = [
      {
        profile.name = "default";
        profile.outputs = [
          {
            criteria = "DVI-D-1";
            transform = "90";
            position = "840,0";
          }
          {
            criteria = "DP-1";
            position = "1920,0";
          }
        ];
      }
      {
        profile.name = "laptop";
        profile.outputs = [
          {
            criteria = "eDP-1";
            scale = 1.0;
          }
        ];
      }
      {
        profile.name = "laptop-dual";
        profile.outputs = [
          {
            criteria = "AU Optronics 0x408D Unknown";
            scale = 1.0;
            position = "2560,0";
          }
          {
            criteria = "Iiyama North America PL2730Q 1153895021477";
            scale = 1.0;
            position = "0,0";
          }
        ];
      }
    ];
  };
}
