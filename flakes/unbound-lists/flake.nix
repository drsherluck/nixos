{
  description = "package of different unbound rules";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux"; #builtins.currentSystem;
    pkgs = nixpkgs.legacyPackages.${system};
    script = pkgs.writeScriptBin "unbound-rules" (builtins.readFile ./unbound.sh);
  in {
    packages.x86_64-linux.default = with pkgs;
      stdenv.mkDerivation {
        name = "unbound-lists";
        src = ./unbound.sh;
        buildInputs = [script bash curl];
        nativeBuildInputs = [makeWrapper];
        unpackPhase = ''
          cp $src $(stripHash $src);
        '';
        installPhase = ''
          mkdir -p $out/bin
          cp unbound.sh $out/bin/unbound-rules
          chmod +x $out/bin/unbound-rules
          wrapProgram $out/bin/unbound-rules --prefix PATH : ${lib.makeBinPath [bash curl]}
        '';
      };
    overlays.default = final: prev: {unbound-lists = self.packages.x86_64-linux.default;};

    # first include this in nixos flake imports:
    # { nixpkgs.overlays = [unbound-lists.overlays.default]; }
    nixosModules.default = self.nixosModules.unbound-rules;
    nixosModules.unbound-rules = {
      config,
      lib,
      pkgs,
      ...
    }:
      with lib; let
        cfg = config.unbound-rules;
        stateDirName = "unbound-rules";
        stateDir = "/var/lib/${stateDirName}";
        updateCommand = opts:
          lib.concatStringsSep " " (["${pkgs.unbound-lists}/bin/unbound-rules update"]
            ++ optional (opts.oisd-nsfw) "oisd-nsfw"
            ++ optional (opts.oisd-big) "oisd-big"
            ++ optional (opts.safesearch) "safesearch");
      in {
        options.unbound-rules = {
          enable = mkEnableOption "enable unbound rules";
          oisd-nsfw = mkEnableOption "include oisd-nsfw unbound rules";
          oisd-big = mkEnableOption "include oisd-big unbound rules for block ads and malware";
          safesearch = mkEnableOption "include force safesearch rules";
        };

        config = mkIf (cfg.enable && config.services.unbound.enable) {
          services.unbound.settings.include =
            []
            ++ optional (cfg.oisd-big) "\"${stateDir}/oisd-big\""
            ++ optional (cfg.oisd-nsfw) "\"${stateDir}/oisd-nsfw\""
            ++ optional (cfg.safesearch) "\"${stateDir}/safesearch\"";

          environment.systemPackages = [pkgs.unbound-lists];

          # avoid crashing unbound if files do not exist yet
          systemd.services.unbound-rules-pre = {
            unitConfig = {
              Description = "unbound-rules-pre: create unbound include files";
              Before = ["unbound.service"];
            };

            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${pkgs.unbound-lists}/bin/unbound-rules create_files";
              StateDirectory = stateDirName;
              Environment = "CONFIG_DIR=${stateDir}";
            };

            wantedBy = ["multi-user.target"];
          };

          # updates the enabled unbound rules
          systemd.services.unbound-rules = {
            unitConfig = {
              Description = "unbound-rules: update unbound rules";
              After = ["unbound.service"];
            };

            serviceConfig = {
              Type = "oneshot";
              ExecStart = updateCommand cfg;
              ExecStartPost = "${pkgs.unbound-lists}/bin/unbound-rules reload";
              StateDirectory = stateDirName;
              Environment = "CONFIG_DIR=${stateDir}";
            };

            wantedBy = ["multi-user.target"];
          };
        };
      };
  };
}
