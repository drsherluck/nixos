{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # cli
    bat
    btop
    ripgrep
    eza
    yazi
    jq
    yq-go
    tokei
    feh
    # apps
    mpv
    discord
    telegram-desktop
    zathura
    typst
    qbittorrent
    # general
    libnotify
    hsetroot
    # wayland
    grim
    slurp
    # i3
    maim
    xclip
    # gtk
    dconf
    # cursors
    bibata-cursors
  ];

  home.pointerCursor = {
    x11.enable = true;
    gtk.enable = true;
    size = 16;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        # xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };

    userDirs = let
      home = config.home.homeDirectory;
    in {
      enable = true;
      createDirectories = false;
      music = "${home}/music";
      download = "${home}/downloads";
      documents = "${home}/documents";
      desktop = "${home}/desktop";
      pictures = "${home}/pictures";
      videos = "${home}/videos";
      templates = "${home}/other/templates";
      publicShare = "${home}/other/share";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Macchiato-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["blue"];
        size = "standard";
        variant = "macchiato";
      };
    };
    cursorTheme = {
      name = config.home.pointerCursor.name;
      package = config.home.pointerCursor.package;
    };
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
    gtk4 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";
      catppuccin = {
        enable = true;
        accent = "blue";
        flavor = "macchiato";
      };
    };
  };
}
