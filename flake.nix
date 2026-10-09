{
  description = "NixOS GNOME configurations for VM and physical machines";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { nixpkgs, ... }: {
    nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./modules/common.nix
        ./modules/gnome.nix
        ./hosts/vm/default.nix
      ];
    };

    nixosConfigurations.zet = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./modules/common.nix
        ./modules/gnome.nix
        ./modules/gaming.nix
        ./hosts/zet/default.nix
      ];
    };

    nixosConfigurations."02i0132" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./modules/common.nix
        ./modules/gnome.nix
        ./modules/gaming.nix
        ./hosts/02i0132/default.nix
      ];
    };

    nixosConfigurations.nuc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./modules/common.nix
        ./modules/gnome.nix
        ./modules/gaming.nix
        ./hosts/nuc/default.nix
      ];
    };

    nixosConfigurations.dell = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./modules/common.nix
        ./modules/gnome.nix
        ./modules/gaming.nix
        ./hosts/dell/default.nix
      ];
    };
  };
}
