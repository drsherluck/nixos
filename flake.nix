{
  description = "nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    unbound-lists = {
      url = "path:flakes/unbound-lists";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs: {
    nixosConfigurations."arrakis" = with inputs;
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/arrakis
          catppuccin.nixosModules.catppuccin
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          unbound-lists.nixosModules.unbound-rules
          sops-nix.nixosModules.sops
          nixos-hardware.nixosModules.common-cpu-intel-cpu-only
          {nixpkgs.overlays = [unbound-lists.overlays.default];}
        ];
        specialArgs = {
          inherit inputs;
        };
      };
    nixosConfigurations."caladan" = with inputs;
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/caladan
          catppuccin.nixosModules.catppuccin
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          unbound-lists.nixosModules.unbound-rules
          sops-nix.nixosModules.sops
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-zenpower
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          {nixpkgs.overlays = [unbound-lists.overlays.default];}
        ];
        specialArgs = {
          inherit inputs;
        };
      };
  };
}
