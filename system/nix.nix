{
  outputs,
  config,
  pkgs,
  ...
}: let
  # https://www.reddit.com/r/NixOS/comments/16n4sbd/comment/k1cf4wf
  nixos-rebuild = pkgs.writeScriptBin "nrb" ''
    #!/usr/bin/env bash
    command=''${1:-switch}
    flake=''${NIXOS_FLAKE:-/etc/nixos}
    sudo nixos-rebuild $command --flake "''${flake}#${config.networking.hostName}"
  '';
  nixos-update = pkgs.writeScriptBin "nru" ''
    #!/usr/bin/env bash
    flake=''${NIXOS_FLAKE:-/etc/nixos}
    nix flake update -I ''${flake}
    sudo nixos-rebuild switch --flake "''${flake}#${config.networking.hostName}"
  '';
in {
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["root" "@wheel"];
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nixpkgs.config = {
    allowUnfree = true;
    chromium.enableWideVine = true;
  };
  nixpkgs.overlays = [outputs.overlays.stable-packages];

  environment.systemPackages = [
    nixos-rebuild
    nixos-update
  ];
}
