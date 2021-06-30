{ config, pkgs, options, lib, ... }:

with lib; {

  options = {
    hyperv.enhancedSession = mkOption
      {
        type = types.bool;
        default = true;
        description = ''
          Enables enhanced hyperv session over RDP
          Enable Guest Services on Hyper-V Management settings and
          don't forget to enable access over VSock on a Admin powershell with:

          % Set-Vm -VmName <VM> -EnhancedSessionTransportType HvSocket
        '';
      };

    hyperv.video = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enables Display Manager support on HyperV
      '';
    };

    hyperv.defaultWindowManager = mkOption
      {
        type = types.separatedString " ";
        default = "${config.services.xserver.displayManager.sessionData.wrapper}";
        description = ''
          If ~/startwm.sh exists as an executable script, it will take priority over this option.
        '';
      };
  };

  config = mkMerge ([
    {
      boot.kernelModules = [ "hv_sock" ];
      virtualisation.hypervGuest.enable = true;
    }

    (mkIf config.hyperv.video {
      services.xserver = {
        modules = [ pkgs.xorg.xf86videofbdev ];
        videoDrivers = [ "hyperv_fb" ];
      };
    })

    (mkIf
      config.hyperv.enhancedSession
      {
        services.xrdp = {
          enable = true;
          defaultWindowManager = config.hyperv.defaultWindowManager;
          package = pkgs.xrdp.overrideAttrs (old: rec {
            configureFlags = old.configureFlags ++ [ " --enable-vsock" ];

            postInstall = old.postInstall + ''
              ${pkgs.gnused}/bin/sed -i -e 's!use_vsock=false!use_vsock=true!g'                               $out/etc/xrdp/xrdp.ini
              ${pkgs.gnused}/bin/sed -i -e 's!security_layer=negotiate!security_layer=rdp!g'                  $out/etc/xrdp/xrdp.ini
              ${pkgs.gnused}/bin/sed -i -e 's!crypt_level=high!crypt_level=none!g'                            $out/etc/xrdp/xrdp.ini
              ${pkgs.gnused}/bin/sed -i -e 's!bitmap_compression=true!bitmap_compression=false!g'             $out/etc/xrdp/xrdp.ini
              ${pkgs.gnused}/bin/sed -i -e 's!FuseMountName=thinclient_drives!FuseMountName=shared-drives!g'    $out/etc/xrdp/sesman.ini
            '';
          });
        };

        environment.etc."X11/Xwrapper.config" = {
          mode = "0644";
          text = ''
            allowed_users=anybody
            needs_root_rights=yes
          '';
        };

        security.pam.services.xrdp-sesman-rdp = {
          text = ''
            auth      include   system-remote-login
            account   include   system-remote-login
            password  include   system-remote-login
            session   include   system-remote-login
          '';
        };

        security.polkit = {
          enable = true;
          extraConfig = ''
                polkit.addRule(function(action, subject) {
                if ((action.id == "org.freedesktop.color-manager.create-device" ||
                action.id == "org.freedesktop.color-manager.modify-profile" ||
                action.id == "org.freedesktop.color-manager.delete-device" ||
                action.id == "org.freedesktop.color-manager.create-profile" ||
                action.id == "org.freedesktop.color-manager.modify-profile" ||
                action.id == "org.freedesktop.color-manager.delete-profile") &&
                subject.isInGroup("users")) {
                return polkit.Result.YES;
            }
            });
          '';
        };
      })
  ]);
}
