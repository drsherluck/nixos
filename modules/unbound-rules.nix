{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.unbound-rules;
  package = pkgs.callPackage ./../pkgs/unbound-rules {};
  stateDirName = "unbound-rules";
  stateDir = "/var/lib/${stateDirName}";
  updateCommand = opts:
    lib.concatStringsSep " " (["${package}/bin/unbound-rules update"]
      ++ optional (opts.oisd-nsfw) "oisd-nsfw"
      ++ optional (opts.oisd-big) "oisd-big"
      ++ optional (opts.youtube) "youtube"
      ++ optional (opts.safesearch) "safesearch");
in {
  options.unbound-rules = {
    enable = mkEnableOption "enable unbound rules";
    oisd-nsfw = mkEnableOption "include oisd-nsfw unbound rules";
    oisd-big = mkEnableOption "include oisd-big unbound rules for block ads and malware";
    safesearch = mkEnableOption "include force safesearch rules";
    youtube = mkEnableOption "block youtube";
  };

  config = mkIf (cfg.enable && config.services.unbound.enable) {
    services.unbound.settings.include =
      []
      ++ optional (cfg.oisd-big) "\"${stateDir}/oisd-big\""
      ++ optional (cfg.oisd-nsfw) "\"${stateDir}/oisd-nsfw\""
      ++ optional (cfg.safesearch) "\"${stateDir}/safesearch\""
      ++ optional (cfg.youtube) "\"${stateDir}/youtube\"";

    environment.systemPackages = [package];

    # avoid crashing unbound if files do not exist yet
    systemd.services.unbound-rules-pre = {
      unitConfig = {
        Description = "unbound-rules-pre: create unbound include files";
        Before = ["unbound.service"];
      };

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${package}/bin/unbound-rules create_files";
        StateDirectory = stateDirName;
        Environment = "CONFIG_DIR=${stateDir}";
      };

      wantedBy = ["multi-user.target"];
    };

    # updates the enabled unbound rules
    systemd.services.unbound-rules = {
      unitConfig = {
        Description = "unbound-rules: update unbound rules";
        After = ["unbound.service" "network-online.target"];
        Wants = ["network-online.target"];
      };

      serviceConfig = {
        Type = "exec";
        ExecStart = updateCommand cfg;
        ExecStartPost = "${package}/bin/unbound-rules reload";
        StateDirectory = stateDirName;
        Environment = "CONFIG_DIR=${stateDir}";
      };

      wantedBy = ["multi-user.target"];
    };

    # update unbound rules every day on midnight
    systemd.timers.unbound-rules = {
      unitConfig = {
        Description = "unbound-rules: timer for unbound-rules.service";
        Requires = config.systemd.services.unbound-rules.name;
      };

      timerConfig = {
        Unit = config.systemd.services.unbound-rules.name;
        OnCalendar = "*-*-* 00:00:00";
      };

      wantedBy = ["timers.target"];
    };
  };
}
