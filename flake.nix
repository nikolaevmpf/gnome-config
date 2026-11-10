{
  description = "NixOS GNOME configurations for VM, work, browsing and gaming hosts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opencode-v2.url = "github:anomalyco/opencode/2a3e7c0f349ba0e9454fa0529ec041cf57e53cb8";

    kimi-code.url = "github:MoonshotAI/kimi-code";
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      mkHost = name: extraModules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.nixosModules.home-manager
            ./modules/base
            ./modules/desktop
            ./modules/home
            ./hosts/${name}
          ] ++ extraModules;
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
        ];

        "02i0132" = mkHost "02i0132" [
          ./modules/roles/work.nix
          ./modules/roles/browsing.nix
          ./modules/roles/gaming.nix
        ];

        zet = mkHost "zet" [
          ./modules/roles/browsing.nix
          ./modules/roles/gaming.nix
        ];

        dell = mkHost "dell" [
          ./modules/roles/work.nix
          ./modules/roles/browsing.nix
        ];
      };
    };
}
