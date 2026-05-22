{
  pkgs,
  ...
}: let
  toggle-kdb-light = pkgs.writeShellScriptBin "toggle-kdb-light" ''
    value=$(brightnessctl -d asus::kbd_backlight get)
    if [[ "$value" -ne $(brightnessctl -d asus::kbd_backlight max) ]]; then
      brightnessctl -d asus::kbd_backlight set +1
    else
      brightnessctl -d asus::kbd_backlight set 0
    fi
  '';
in {
  home.packages = with pkgs; [
    killall
    brightnessctl
    toggle-kdb-light
  ];

  services.wlsunset = {
    enable = true;
    latitude = 52.3676;
    longitude = 4.9041;
  };

  programs.hyprpanel = {
    enable = false;
    # dontAssertNotificationDaemons = true;
    settings = {
      scalingPriority = "hyprland";
      notifications.showActionsOnHover = true;
      bar.customModules.storage.paths = [
        "/"
      ];
      theme.bar.floating = true;
      bar.autoHide = "never";
      theme.bar.border.width = "0.12em";
      bar.customModules.microphone.label = true;
      menus.clock.weather.location = "Amsterdam";
      menus.clock.weather.unit = "metric";
      menus.clock.time.military = true;
      menus.clock.weather.enabled = false;
      menus.clock.time.hideSeconds = false;
      theme.font.name = "Consolas Nerd Font";
      theme.font.label = "Consolas Nerd Font";
      theme.font.style = "normal";
      theme.font.size = "0.8rem";
      theme.bar.buttons.radius = "0.2em";
      bar.launcher.icon = "";
      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = false;
      bar.workspaces.show_numbered = true;
      theme.bar.buttons.workspaces.enableBorder = false;
      bar.workspaces.monitorSpecific = true;
      bar.workspaces.showWsIcons = false;
      theme.osd.enable = true;
      menus.power.lowBatteryNotification = true;
      bar.layouts = {
        "*" = {
          left = [
            "workspaces"
          ];
          right = [
            "netstat"
            "network"
            "volume"
            "bluetooth"
            "battery"
            "systray"
            "cputemp"
            "ram"
            "clock"
            "notifications"
          ];
        };
      };
      wallpaper.enable = false;
      theme.bar.menus.cards = "#1e1e2e";
      theme.bar.menus.monochrome = false;
      theme.bar.transparent = true;
      theme.bar.buttons.monochrome = false;
      theme.bar.buttons.background_opacity = 0;
      theme.matugen = false;
      theme.bar.menus.opacity = 100;
      bar.clock.icon = "";
      bar.clock.format = "%b, %a %d  %H:%M:%S (%:z)";
      bar.bluetooth.label = false;
      bar.network.truncation = false;
      bar.network.label = true;
      bar.network.showWifiInfo = true;
      theme.bar.buttons.separator.margins = "0.1em";
      bar.customModules.ram.labelType = "percentage";
      theme.bar.buttons.modules.ram.spacing = "0.45em";
      bar.customModules.ram.round = true;
      bar.notifications.show_total = false;
    };
  };

  programs.ashell = {
    enable = true;
    systemd.enable = true;
    settings = {
      position = "Top";
      animations.enabled = false;
      modules = {
        left = ["Workspaces"];
        center = ["WindowTitle"];
        right = [
          "MediaPlayer"
          "SystemInfo"
          "Tray"
          "Settings"
          "Tempo"
          "Privacy"
        ];
      };
      appearance = {
        style = "Islands";
        opacity = 0.8;
        scale_factor = 0.8;
        font_name = "SFMono Nerd Font Bold";
        workspace_colors = [
          { base = "#fab387"; text = "#000000"; }
        ];
      };
      workspaces = {
        visibility_mode = "MonitorSpecific";
        enable_workspace_filling = false;
      };
      window_title = {
        truncate_title_after_length = 64;
      };
      tempo = {
        format = "%a %d %b  %H:%M:%S";
      };
      system_info = {
        cpu = {
          warn_threshold = 60;
          alert_threshold = 80;
        };
        memory = {
          warn_threshold = 60;
          alert_threshold = 80;
        };
        temperature = {
          warn_threshold = 60;
          alert_threshold = 80;
        };
      };
    };
  };

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-hyprland];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.variables = ["--all"];
    settings = {
      "$mod" = "SUPER";
      "$term" = "ghostty";
      "$browser" = "chromium";

      # decoration = {
      #   rounding = 0;
      #   active_opactiy = 1.0;
      #   inactive_opactiy = 0.8;
      #   drop_shadow = false;
      # };

      general = {
        gaps_in = 1;
        gaps_out = 1;
        border_size = 2;
        # no_border_on_floating = false;
        allow_tearing = true;
      };

      # windowrulev2 = "immediate, class:^(tengine)$";

      misc = {
        # disable vsync
        vrr = 0;
        vfr = true;

        enable_anr_dialog = false;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        background_color = "0x000000";
      };

      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      animations = {
        enabled = false;
      };

      exec-once = [
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type text --watch cliphist store"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      ];

      monitor = [
        "eDP-1, preferred, auto-center-down, 1"
        "DP-2, preferred, auto-center-up, 1"
      ];

      bindl = [
        ",switch:on:Lid Switch,exec,hyprctl keyword monitor \"eDP-1, disable\""
        ",switch:off:Lid Switch,exec,hyprctl keyword monitor \"eDP-1, preferred, auto-center-down, 1\""
      ];

      binds = {
        drag_threshold = 10;
      };

      bindm = [
        "$mod, mouse:272, movewindow"
      ];

      input = {
        accel_profile = "flat";
        touchpad = {
          scroll_factor = 0.5;
        };
      };

      device = {
        name = "ascp1a01:00-093a:3014-touchpad";
        sensitivity = -0.1;
      };

      bind = [
        "$mod, B, exec, $browser"
        "$mod, Return, exec, $term"
        "$mod, D, exec, killall rofi || rofi -show run"
        "$mod SHIFT, Q, killactive"
        "$mod SHIFT, E, exit"
        "$mod, F, fullscreen, 2"
        "$mod SHIFT, F, fullscreen, 0"
        "$mod CTRL, F, fullscreen, 0 1"
        "$mod, Space, togglefloating"
        "$mod, L, exec, swaylock"

        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod ALT, K, workspace, e+1"
        "$mod ALT, J, workspace, e-1"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SOURCE@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"

        ", XF86MonBrightnessUp, exec, brightnessctl set +10%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"

        ", XF86KbdLightOnOff, exec, toggle-kdb-light"
        ", XF86KbdBrightnessUp, exec, brightnessctl -d asus::kbd_backlight set +1"
        ", XF86KbdBrightnessDown, exec, brightnessctl -d asus::kbd_backlight set 1-"

        "$mod SHIFT, S, exec, grim -g \"$(slurp -d)\" - | wl-copy -t image/png"
        ", Print, exec, grim - | wl-copy -t image/png"
      ];
    };
  };
}
