{pkgs, ...}: let
  gobar = pkgs.callPackage ../../pkgs/gobar.nix {};
in {
  imports = [
    ../../modules/autorandr-rs.nix
  ];

  home.packages = [gobar];

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = null;
    extraConfig = builtins.readFile ./config;
  };

  # I do not like display managers
  home.file.".xinitrc".text = ''
    [ -f ~/.xprofile ] && source ~/.xprofile
    [ -f ~/.Xresources ] && xrdb merge ~/.Xresources

    if test -z "$DBUS_SESSION_BUS_ADDRESS"; then
      eval $(dbus-launch --exit-with-session --sh-syntax)
    fi
    systemctl --user import-environment DISPLAY XAUTHORITY

    if command -v dbus-update-activation-environment >/dev/null 2>&1; then
      dbus-update-activation-environment DISPLAY XAUTHORITY
    fi

    systemctl --user start xsession.service
    exec i3
  '';

  xsession.enable = true;
  systemd.user.services.xsession = {
    Unit = {
      Description = "A unit to start graphical-session.target";
      BindsTo = "graphical-session.target";
      Before = "graphical-session.target";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/true";
      RemainAfterExit = "yes";
      Restart = "on-failure";
    };
  };

  services.picom = {
    enable = true;
    vSync = true;
    backend = "glx";
  };

  services.redshift = {
    enable = true;
    # city center of delft (nieuwe kerk)
    latitude = 52.012093;
    longitude = 4.360011;
  };

  # Disables HiDPI
  # xresources.extraConfig = ''
  #   Xft.dpi: 96
  # '';

  # this should be moved to hosts
  # it is host specific configuration
  services.autorandr-rs = {
    enable = true;
    enableNotifications = true;
    config = {
      monitor = {
        DP-0 = {
          product = "V277U";
          serial = "TDCEE001852B";
        };
        DVI-D-0 = {
          product = "ZOWIE XL LCD";
          serial = "D7H05227SL0";
        };
      };
      layout.default.config = {
        DVI-D-0 = {
          width = 1920;
          height = 1080;
          x = 0;
          y = 0;
          rotate = "left";
        };
        DP-0 = {
          width = 2560;
          height = 1440;
          x = 1080;
          y = 0;
          primary = true;
        };
      };
    };
  };
}
