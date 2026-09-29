{
  description = "NixOS GNOME configurations for VM and physical machines";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { nixpkgs, ... }: {
    nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./modules/common.nix
        ./modules/gnome.nix
        ./modules/gaming.nix
        ./hosts/vm/default.nix
      ];
    };

    # Add desktop-nvidia and dell outputs after their hardware details
    # and filesystem layouts have been collected.
  };
}
