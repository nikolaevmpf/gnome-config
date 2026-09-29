{ ... }:
{
  networking.hostName = "zet";

  # This host module is staged. Add its filesystems, bootloader,
  # GPU driver and firmware settings after collecting zet hardware details.
  # The flake output must not be enabled before those are known.
}
