{ stdenv, lib, kernel, fetchpatch }:

stdenv.mkDerivation rec {
  name = "hid-multitouch-onenetbook4-${version}";
  version = kernel.version;

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  src = ./.;
  patches = [
    (fetchpatch {
      url = "https://marc.info/?l=linux-input&m=161847127221531&q=p3";
      name = "goodix-stylus-mastykin-1-pen-support.patch";
      sha256 = "sha256-1oc8OvfhScYvtsMeV9A4hU+09i59tEJ6HZS6jspsJR8=";
    })
    (fetchpatch {
      url = "https://marc.info/?l=linux-input&m=161847127221531&q=p4";
      name = "goodix-stylus-mastykin-2-buttons.patch";
      sha256 = "sha256-HxmR8iEgoj4PJopGWJdWsjFxbfISwTMzz+HyG81mRG4=";
    })
  ];

  postUnpack = ''
    tar -C goodix-stylus-mastykin \
      --strip-components=3 -xf ${kernel.src} --wildcards \
      '*/drivers/hid/hid-ids.h' '*/drivers/hid/hid-multitouch.c'
  '';
  patchFlags = "-p3";
  postPatch = ''
    mv hid-multitouch.c hid-multitouch-onenetbook4.c
    substituteInPlace hid-multitouch-onenetbook4.c --replace \
      '.name = "hid-multitouch",' \
      '.name = "hid-multitouch-onenetbook4",'
    substituteInPlace hid-multitouch-onenetbook4.c --replace \
      I2C_DEVICE_ID_GOODIX_0113 \
      0x011A
  '';

  makeFlags = [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  meta = with lib; {
    description = "hid-multitouch module patched for OneNetbook 4";
    platforms = platforms.linux;
  };
}