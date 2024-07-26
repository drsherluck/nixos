{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.autorandr-rs;
  inherit (pkgs) writeScriptBin;

  configModule = types.submodule {
    options = {
      monitor = mkOption {
        type = types.attrsOf monitorModule;
        description = ''
          Output name of EDID mappings.
          Use `monitor-layout print-edids` to get current values.
        '';
        default = {};
      };

      layout = mkOption {
        type = types.attrsOf layoutModule;
        description = "Layout profile configurations.";
        default = {};
      };
    };
  };

  monitorModule = types.submodule {
    options = {
      product = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      serial = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
    };
  };

  layoutModule = types.submodule {
    options = {
      config = mkOption {
        type = types.attrsOf monitorConfigModule;
        description = ''
          List of per monitor configuration that will be used for this layout.
          The layout will only be active if all the monitors are in the list are connected.
        '';
        default = {};
      };
    };
  };

  monitorConfigModule = types.submodule {
    options = {
      width = mkOption {
        type = types.int;
        description = "The horizontal resolution.";
      };
      height = mkOption {
        type = types.int;
        description = "The vertical resolution.";
      };
      x = mkOption {
        type = types.int;
        description = "The x position.";
      };
      y = mkOption {
        type = types.int;
        description = "The y position.";
      };
      primary = mkOption {
        type = types.bool;
        description = "Is this the primary display?";
        default = false;
      };
      rotate = mkOption {
        type = types.nullOr types.str;
        description = ''
          Either "left" or "right" rotation.
        '';
        default = null;
      };
    };
  };

  configStr = concatStringsSep "\n" (
    mapAttrsToList monitorToString cfg.config.monitor
    ++ mapAttrsToList layoutToString cfg.config.layout
  );

  monitorToString = name: config:
    with config;
      concatStringsSep " " (["monitor \"${toString name}\""]
        ++ optional (product != null) "product=\"${toString product}\""
        ++ optional (serial != null) "serial=\"${toString serial}\"");

  layoutToString = name: layout:
    concatStringsSep "\n" (["layout \"${toString name}\" {"]
      ++ [(concatStringsSep " " (["  matches"] ++ mapAttrsToList (k: _: "\"${toString k}\"") layout.config))]
      ++ [(concatStringsSep "\n" (mapAttrsToList monitorConfigToString layout.config)) "}"]);

  monitorConfigToString = name: config:
    with config;
      concatStringsSep " " (["  monitor \"${toString name}\" w=${toString width} h=${toString height} x=${toString x} y=${toString y}"]
        ++ optional (primary != false) "primary=true"
        ++ optional (rotate != null) "rotate=\"${toString rotate}\"");
in {
  options.services.autorandr-rs = {
    enable = mkEnableOption "autorandr-rs configuration";
    config = mkOption {
      type = configModule;
    };
    enableNotifications = mkEnableOption "notify of display changes through notify-send";
  };

  config = mkIf cfg.enable (
    let
      package = pkgs.callPackage ./../pkgs/autorandr-rs.nix {};
      configName = "autorandr-rs/config.kdl";
      service-name = "autorandr-rs-daemon";
      exec =
        writeScriptBin service-name
        (
          ''
            #!/bin/sh
            ${package}/bin/monitor-layout daemon ${config.home.homeDirectory}/.config/${configName}
          ''
          + (
            optionalString cfg.enableNotifications
            ''| while read cfg ; do ${pkgs.libnotify}/bin/notify-send -a autorandr-rs -t 3000 "switched to $cfg" ; done''
          )
        );
    in {
      home.packages = [package];

      xdg.configFile."${configName}".text = configStr;

      systemd.user.services.autorandr-rs = {
        Unit = {
          Description = "autorandr-rs: automatic display configuration daemon";
          After = ["graphical-session-pre.target"];
          PartOf = ["graphical-session.target"];
        };

        Service = {
          Type = "simple";
          ExecStart = "${exec}/bin/${service-name}";
          Restart = "always";
        };

        Install.WantedBy = ["graphical-session.target"];
      };
    }
  );
}
