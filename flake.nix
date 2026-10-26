{
  description = "NixOS GNOME configurations for VM and physical machines";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  inputs.opencode-v2.url = "github:anomalyco/opencode/2a3e7c0f349ba0e9454fa0529ec041cf57e53cb8";

  inputs.home-manager = {
    url = "github:nix-community/home-manager/release-26.05";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, opencode-v2, ... }: {
    nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.home-manager
        ./modules/home-manager.nix
        ./modules/common.nix
        ./modules/gnome.nix
        ./hosts/vm/default.nix
      ];
    };

    nixosConfigurations.zet = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.home-manager
        ./modules/home-manager.nix
        ./modules/common.nix
        ./modules/gnome.nix
        ./modules/gaming.nix
        ./hosts/zet/default.nix
      ];
    };

    nixosConfigurations."02i0132" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit opencode-v2; };
      modules = [
        home-manager.nixosModules.home-manager
        ./modules/home-manager.nix
        ./modules/common.nix
        ./modules/gnome.nix
        ./modules/gaming.nix
        ./hosts/02i0132/default.nix
      ];
    };

    nixosConfigurations.nuc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.home-manager
        ./modules/home-manager.nix
        ./modules/common.nix
        ./modules/gnome.nix
        ./modules/gaming.nix
        ./hosts/nuc/default.nix
      ];
    };

    nixosConfigurations.dell = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.home-manager
        ./modules/home-manager.nix
        ./modules/common.nix
        ./modules/gnome.nix
        ./modules/gaming.nix
        ./hosts/dell/default.nix
      ];
    };
  };
}
