{
  description = "System, User, and dotfile configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... }:
    let
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          modules = [ 
            ./configuration.nix
            sops-nix.nixosModules.sops 
          ];
        };
      };
      homeConfigurations = {
        bryancj = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [./home.nix ];
        };
      };
    };
}
