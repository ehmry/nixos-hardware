{ lib, config, pkgs, ... }:
{
  imports = [
    ../.
    ../../../common/pc/laptop/hdd
    ../../../common/pc/uefi32
  ];

  # TODO:
  #  - [ ] Pin kernel to ensure patch succeeds
  #  - [ ] Find how to get source dir
  #  - [ ] build kernel with radeon vbios loading support
  #        https://discourse.nixos.org/t/how-to-install-a-linux-kernel-patch/6889
  #  - [ ] put firmware in the right place
  #        - Load custom Radeon firmware for Macbook Pro / Kernel & Hardware / Arch Linux Forums https://bbs.archlinux.org/viewtopic.php?pid=1810437#p1810437
  #        - https://discourse.nixos.org/t/trying-to-include-custom-firmware-but-it-doesnt-appear-under-run-current-system/3044
  boot.kernelParams = ["nomodeset"];
 
      boot.kernelPatches = [
        { name = "radeon-vbios-from-dump";
          patch = ./radeon_bios.patch ;
        }
      ];
}
