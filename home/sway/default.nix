{
  config,
  pkgs,
  ...
}: {
  programs.swaylock.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    swaynag.enable = true;
    config = null;
    extraConfig = builtins.readFile ./config;
  };

  home.packages = with pkgs; [
    wl-clipboard
    xwaylandvideobridge
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
    ];
  };
}
