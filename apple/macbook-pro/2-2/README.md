# Apple MacBook Pro 2,2

This hardware has some challenging quirks requiring workarounds documented below. Before you get started, have a look over Andreas Baumann's detailed post [Archlinux on a MacBook Pro 15'' Model A1211](http://www.andreasbaumann.cc/blog/archlinux-macbook-a1211/) to get a sense of what is involved.

This guide assumes you want a 64-bit OS booted via UEFI, but the 32 bit EFI is only a problem for 64-bit OSes, and the Radeon vBIOS is only missing in EFI mode, so if you are willing to settle for 32 bit and MBR you can avoid those issues. Just be aware that attempting to set a graphical mode during install will still crash due to mising vbios because you will be booted in EFI mode. Use a text-only install method.

## 32 Bit UEFI

Apple's late-2006 machines run a 32-bit EFI firmware which won't boot 64-bit EFI programs. You will need to modify your install image to boot BIOS-only, and make sure to install a 32bit EFI bootloader (which this include does). See [/common/pc/uefi32](../../../common/pc/uefi32/README.md).

## Blessing the boot partition

If you created your own boot partition (for example, after wiping your hard disk), you will notice an extra 30 second delay before GRUB. To speed up boot, you need to "bless" the boot partition.

Boot Mac OS (recovery or install media works) and run:

``` sh
bless --device /dev/<your boot partion> --setBoot --verbose
```

Use `diskutil list` to locate your boot partition. If you followed [the manual](https://nixos.org/manual/nixos/stable/index.html#sec-installation-partitioning-UEFI) so that the third partition is boot, it would be `disk0s3`

For more details, read [reducing the 30 second delay when starting 64-bit Ubuntu in BIOS mode on the old 32-bit EFI Macs | mattgadient.com](https://mattgadient.com/reducing-the-30-second-delay-when-starting-64-bit-ubuntu-in-bios-mode-on-the-old-32-bit-efi-macs/) (although note that you should leave off the `--legacy` flag since we are booting in EFI mode).

## Missing radeon vbios in UEFI mode

You will find that the system locks hard when Linux attempts to set a display mode via KMS. 

This is because in EFI mode, on this model and many other Apple machines, the Radeon vbios firmware is loaded by Apple's OS via a proprietary method early in the EFI boot process rather than being made available via a standard ACPI table.

To work around this, you need:

 - A kernel with a patched radeon module capable of loading vbios from a file (already taken care of here)
 - A dump of your model's vbios
  - Since it is readable via ACPI in BIOS mod, it can be obtained by booting Linux in BIOS mode using a specially crafted BIOS-only optical disk or hard drive (USB-booting into BIOS isn't supported in this model). 

### More info

 - TL;DR steps in Andreas Baumann's post: [Load custom Radeon firmware for Macbook Pro / Kernel & Hardware / Arch Linux Forums](https://bbs.archlinux.org/viewtopic.php?pid=1810437#p1810437)
 - The bug where this was figured out and the radeon patch is attached: [26891 – Radeon KMS fails with inaccessible AtomBIOS on systems with (U)EFI boot](https://bugs.freedesktop.org/show_bug.cgi?id=26891#c3)

## iSight Camera Firmware

## Quick reference

* [Mac startup key combinations - Apple Support](https://support.apple.com/en-us/HT201255)