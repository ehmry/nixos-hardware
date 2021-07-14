{ lib, pkgs, ... }:
{
  hardware.nvidia.modesetting.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.enable = true;
  # otherwise offloading will not work
  hardware.nvidia.nvidiaPersistenced = true;

  hardware.nvidia.prime = {
    # Bus ID of the Intel GPU.
    intelBusId = lib.mkDefault "PCI:0:2:0";
    # Bus ID of the NVIDIA GPU.
    nvidiaBusId = lib.mkDefault "PCI:1:0:0";
  };

  # set output source to Nvidia for HDMI port
  systemd.user.services.xrandr-outputsource = {
    script = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource NVIDIA-G0 modesetting
    '';
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    enable = true;
  };
}
