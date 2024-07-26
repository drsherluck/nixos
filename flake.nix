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

  outputs = {
    disko,
    nixpkgs,
    home-manager,
    unbound-lists,
    sops-nix,
    ...
  }: {
    nixosConfigurations."arrakis" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/arrakis
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager
        unbound-lists.nixosModules.unbound-rules
        sops-nix.nixosModules.sops
        {nixpkgs.overlays = [unbound-lists.overlays.default];}
      ];
    };
    nixosConfigurations."caladan" = nixpkgs.lib.nixosSystem {
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
