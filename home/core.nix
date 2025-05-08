{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty
    ./chromium
    ./dunst
    ./fastfetch
    ./ghostty
    ./git
    ./mpv
    ./neovim
    ./rofi
    ./starship
    ./tmux
    ./zsh
  ];

  home.packages = with pkgs; [
    # cli
    age
    ripgrep
    eza
    jq
    yq-go
    tokei
    feh
    pass
    lz4
    nix-search
    # apps
    discord
    telegram-desktop
    typst
    qbittorrent
    # general
    libnotify
    hsetroot
    # wayland
    grim
    slurp
    # i3
    stable.maim
    xclip
    # gtk
    dconf
    # cursors
    bibata-cursors
  ];

  catppuccin = {
    enable = true;
    accent = "blue";
    flavor = "mocha";
    # overrides
    dunst.flavor = "macchiato";
    gtk.enable = false;
    mpv.enable = false;
    tmux.enable = false;
    kvantum = {
      accent = "blue";
      flavor = "macchiato";
    };
  };

  programs = {
    bat.enable = true;
    btop = {
      enable = true;
      settings = {
        theme_background = false;
      };
    };
    yazi.enable = true;
    zathura.enable = true;
    gpg.enable = true;
    spotify-player.enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  home.pointerCursor = {
    x11.enable = true;
    gtk.enable = true;
    size = 16;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
  };

  home.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-wlr
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
    };
  };
}
