{
  description = "nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    catppuccin.url = "github:catppuccin/nix";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    sharedModules = with inputs; [
      catppuccin.nixosModules.catppuccin
      disko.nixosModules.disko
      home-manager.nixosModules.home-manager
      sops-nix.nixosModules.sops
    ];
  in rec {
    overlays = import ./overlays {inherit inputs;};
    nixosConfigurations = with inputs; {
      arrakis = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          sharedModules
          ++ [
            ./hosts/arrakis
            nixos-hardware.nixosModules.common-cpu-intel-cpu-only
            # https://github.com/NixOS/nixpkgs/issues/328972
            ({lib, ...}: {
              hardware.nvidia.modesetting.enable = lib.mkForce false;
              boot.kernelParams = ["nvidia-drm.modeset=1"];
            })
          ];
        specialArgs = {inherit inputs outputs;};
      };
      caladan = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          sharedModules
          ++ [
            ./hosts/caladan
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-cpu-amd-zenpower
            nixos-hardware.nixosModules.common-cpu-amd-pstate
          ];
        specialArgs = {inherit inputs outputs;};
      };
      kronin = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          sharedModules
          ++ [
            ./hosts/kronin
            nixos-hardware.nixosModules.dell-xps-15-9510
            nixos-hardware.nixosModules.dell-xps-15-9510-nvidia
            # https://github.com/NixOS/nixpkgs/issues/328972
            ({lib, ...}: {
              hardware.nvidia.modesetting.enable = lib.mkForce false;
              boot.kernelParams = ["nvidia-drm.modeset=1"];
            })
          ];
        specialArgs = {inherit inputs outputs;};
      };
    };
  };
}
