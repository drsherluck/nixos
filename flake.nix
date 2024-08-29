{
  description = "nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # for broken nvidia
    nixpkgs-pinned.url = "github:nixos/nixpkgs?rev=e9ee548d90ff586a6471b4ae80ae9cfcbceb3420";
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

  outputs = inputs: let
    sharedModules = with inputs; [
      catppuccin.nixosModules.catppuccin
      disko.nixosModules.disko
      home-manager.nixosModules.home-manager
      sops-nix.nixosModules.sops
    ];
  in {
    nixosConfigurations."arrakis" = with inputs;
      let
        nvidia-overlay = inputs: (final: prev: {
          final.linuxPackages = inputs.nixpkgs-pinned.linuxPackages;
          final.nvidia_x11 = inputs.nixpkgs-pinned.nvidia_x11;
        });
      in
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          sharedModules
          ++ [
            ./hosts/arrakis
            nixos-hardware.nixosModules.common-cpu-intel-cpu-only
            {nixpkgs.overlays = [ (nvidia-overlay inputs) ];}
          ];
        specialArgs = {inherit inputs;};
      };
    nixosConfigurations."caladan" = with inputs;
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          sharedModules
          ++ [
            ./hosts/caladan
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-cpu-amd-zenpower
            nixos-hardware.nixosModules.common-cpu-amd-pstate
          ];
        specialArgs = {inherit inputs;};
      };
    nixosConfigurations."kronin" = with inputs;
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          sharedModules
          ++ [
            ./hosts/kronin
            nixos-hardware.nixosModules.dell-xps-15-9510
          ];
        specialArgs = {inherit inputs;};
      };
  };
}
