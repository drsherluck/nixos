{
  description = "nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
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
    nixosConfigurations = with inputs; let
      # https://github.com/NixOS/nixpkgs/issues/328972
      disable-nvidia-modeset = {lib, ...}: {
        hardware.nvidia.modesetting.enable = lib.mkForce false;
        boot.kernelParams = ["nvidia-drm.modeset=1"];
      };
    in {
      arrakis = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          sharedModules
          ++ [
            ./hosts/arrakis
            nixos-hardware.nixosModules.common-cpu-intel-cpu-only
            disable-nvidia-modeset
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
            disable-nvidia-modeset
          ];
        specialArgs = {inherit inputs outputs;};
      };
      # https://nixos.wiki/wiki/Creating_a_NixOS_live_CD
      # https://nix.dev/tutorials/nixos/building-bootable-iso-image.html
      # build:   nix build .#nixosConfigurations.iso.config.system.build.images.isoImage
      # install: sudo dd if=result/iso/*.iso of=/dev/sdX bs=4M status=progress
      minimal-iso-x64 = nixpkgs-stable.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs-stable}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ({pkgs, ...}: {
            isoImage.squashfsCompression = "lz4";
            networking.wireless.enable = pkgs.lib.mkForce false;
            networking.networkmanager.enable = true;
            environment.systemPackages = with pkgs; [
              ripgrep
              git
              zsh
              neovim
              tree
              nvme-cli
            ];
          })
        ];
      };
    };
  };
}
