{
  description = "package of different unbound rules";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    oisd-big = {
      url = "file+https://big.oisd.nl/unbound";
      flake = false;
    };
    oisd-nsfw = {
      url = "file+https://nsfw.oisd.nl/unbound";
      flake = false;
    };
    stevenblack-hosts = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };
    google-supported-domains = {
      url = "file+https://www.google.com/supported_domains";
      flake = false;
    };
  };
  outputs = {
    self,
    nixpkgs,
    oisd-big,
    oisd-nsfw,
    stevenblack-hosts,
    google-supported-domains,
  }: let
    system = "x86_64-linux"; #builtins.currentSystem;
    pkgs = nixpkgs.legacyPackages.${system};
    lib = pkgs.lib;

    # convert stevenblack hosts file to unbound config
    sb-lines = lib.splitString "\n" (lib.readFile "${stevenblack-hosts}/hosts");
    sb-filtered = lib.filter (line: lib.hasPrefix "0.0.0.0" line) sb-lines;
    sb-domains = map (line: (lib.strings.removePrefix "0.0.0.0 " line)) sb-filtered;
    sb-cleaned = lib.filter (d: d != "0.0.0.0") (map (domain: (builtins.elemAt (lib.strings.splitString " " domain) 0)) sb-domains);
    stevenblack-unbound = builtins.toFile "stevenblack" (lib.concatStringsSep "\n" (["server:"] ++ (map (domain: "local-zone: \"${domain}\" always_nxdomain") sb-cleaned)));

    # create safesearch config (with no youtube restriction)
    google-lines = map (x: lib.removePrefix "." x) (lib.filter (line: line != "") (lib.splitString "\n" (lib.readFile "${google-supported-domains}")));
    google-redirects = map (domain: "local-zone: \"${domain}\" redirect") google-lines;
    google-cnames = map (domain: "local-data: \"${domain} CNAME forcesafesearch.google.com\"") google-lines;
    google-safesearch = google-redirects ++ google-cnames;
    duckduckgo-safesearch = [
      "local-zone: \"duckduckgo.com\" redirect"
      "local-data: \"duckduckgo.com CNAME safe.duckduckgo.com\""
    ];
    yandex-safesearch = [
      "local-zone: \"yandex.com\" redirect"
      "local-data: \"yandex.com A 213.180.193.56\""
      "local-zone: \"yandex.ru\" redirect"
      "local-data: \"yandex.ru A 213.180.193.56\""
      "local-zone: \"yandex.ua\" redirect"
      "local-data: \"yandex.ua A 213.180.193.56\""
      "local-zone: \"yandex.by\" redirect"
      "local-data: \"yandex.by A 213.180.193.56\""
      "local-zone: \"yandex.kz\" redirect"
      "local-data: \"yandex.kz A 213.180.193.56\""
    ];
    bing-safesearch = [
      "local-zone: \"bing.com\" redirect"
      "local-data: \"bing.com CNAME strict.bing.com\""
    ];
    pixaby-safesearch = [
      "local-zone: \"pixaby.com\" redirect"
      "local-data: \"pixabay.com CNAME safesearch.pixabay.com\""
    ];
    safesearch = google-safesearch ++ duckduckgo-safesearch ++ yandex-safesearch ++ bing-safesearch ++ pixaby-safesearch;
    safesearch-unbound = builtins.toFile "safesearch" (lib.concatStringsSep "\n" (["server:"] ++ safesearch));
  in {
    packages.x86_64-linux.default = with pkgs;
      stdenv.mkDerivation {
        name = "unbound-lists";
        src = self;
        installPhase = ''
          mkdir -p $out;
          cp ${stevenblack-unbound} $out/stevenblack-hosts
          cp ${oisd-big} $out/oisd-big
          cp ${oisd-nsfw} $out/oisd-nsfw
          cp ${safesearch-unbound} $out/safesearch
        '';
      };
    overlays.default = final: prev: {unbound-lists = self.packages.x86_64-linux.default;};

    # first include in nixos flake imports:
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
      in {
        options.unbound-rules = {
          enable = mkEnableOption "enable unbound rules";
          stevenblack = mkEnableOption "include stevenblack hosts file rules";
          oisd-nsfw = mkEnableOption "include oisd-nsfw unbound rules";
          oisd-big = mkEnableOption "include oisd-big unbound rules for block ads and malware";
          safesearch = mkEnableOption "include force safesearch rules";
        };

        config = mkIf (cfg.enable && config.services.unbound.enable) (
          let
            rules = pkgs.unbound-lists;
          in {
            services.unbound.settings.include =
              []
              ++ optional (cfg.stevenblack) "\"${rules}/stevenblack-hosts\""
              ++ optional (cfg.oisd-nsfw) "\"${rules}/oisd-nsfw\""
              ++ optional (cfg.oisd-big) "\"${rules}/oisd-big\""
              ++ optional (cfg.safesearch) "\"${rules}/safesearch\"";
          }
        );
      };
  };
}
