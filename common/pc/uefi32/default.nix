{ lib, config, pkgs, ... }:

{
  # Grub to work around 32 bit efi
  # https://nixos.wiki/wiki/Bootloader#Installing_x86_64_NixOS_on_IA-32_UEFI
  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
    };
    grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
      forcei686 = true;
    };
  };
}
