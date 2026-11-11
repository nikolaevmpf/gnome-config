{
  description = "NixOS GNOME configurations for VM, work, browsing and gaming hosts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Сохраняем собственный nixpkgs: Kimi Code требует новые Node.js
    # и fetchPnpmDeps из nixos-unstable.
    kimi-code.url = "github:MoonshotAI/kimi-code";
  };

  outputs =
    inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      mkHost =
        name: extraModules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.nixosModules.home-manager
            ./modules/base
            ./modules/desktop
            ./modules/home
            ./hosts/${name}
          ]
          ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        vm = mkHost "vm" [
          ./modules/roles/virtualization.nix
        ];

        nuc = mkHost "nuc" [
          ./modules/roles/work.nix
          ./modules/roles/browsing.nix
          ./modules/roles/virtualization.nix
          ./modules/roles/development.nix
          ./modules/roles/max.nix
        ];

        "02i0132" = mkHost "02i0132" [
          ./modules/roles/work.nix
          ./modules/roles/browsing.nix
          ./modules/roles/gaming.nix
          ./modules/roles/virtualization.nix
          ./modules/roles/development.nix
          ./modules/roles/max.nix
        ];

        zet = mkHost "zet" [
          ./modules/roles/browsing.nix
          ./modules/roles/gaming.nix
        ];

        dell = mkHost "dell" [
          ./modules/roles/work.nix
          ./modules/roles/browsing.nix
          ./modules/roles/virtualization.nix
        ];
      };
    };
}
