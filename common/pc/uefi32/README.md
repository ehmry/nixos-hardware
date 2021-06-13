# 32 Bit UEFI

This module forces use of a 32bit EFI GRUB, needed to boot 64bit OSes on systems with a 64-bit CPU but 32-bit EFI firmware, such as Apple's ["Late 2006"](http://refit.sourceforge.net/info/apple_efi.html) hardware.

## Booting 64-bit install media
Before you can utilize this module, you will need to somehow boot your 64-bit install media, which as-is will fail since firmware will prefer the EFI program over MBR, but it will fail to load because it is 64bit. 

I'm aware of three options:

 - First install a 32-bit OS with a 32-bit EFI bootloader (GRUB) then manually type the boot params for your 64-bit installer into GRUB's console. This is detailed at [Bootloader#Installing x86_64 NixOS on IA-32 UEFI](Installing x86_64 NixOS on IA-32 UEFI)). Importing this module should be sufficient for configuring GRUB correctly on both the initial 32-bit system and the bootstrapped 64-bit one.
 - Modify your 64-bit install image to force it to boot in BIOS/MBR mode. This is what I did. TODO: link
 - Modify your install image to have a 32-bit EFI bootloader (like this module does but for the install media). This seems cleanest but is theoretical and untested.