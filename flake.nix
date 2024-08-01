{
  description = "nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
  };

  outputs = inputs: {
    nixosConfigurations."arrakis" = with inputs;
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/arrakis
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          unbound-lists.nixosModules.unbound-rules
          sops-nix.nixosModules.sops
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
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          unbound-lists.nixosModules.unbound-rules
          sops-nix.nixosModules.sops
          {nixpkgs.overlays = [unbound-lists.overlays.default];}
        ];
      };
  };
}
