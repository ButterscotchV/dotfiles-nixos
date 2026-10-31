{
  pkgs,
  libErosanix,
  ...
}:

let
  fusermountCompat = pkgs.writeShellScriptBin "fusermount" ''
    exec /run/wrappers/bin/fusermount3 "$@"
  '';

  xwintab = pkgs.callPackage ./xwintab { };
in
{
  aternos-thanos = pkgs.callPackage ./aternos-thanos { };

  rebelle = pkgs.callPackage ./rebelle {
    inherit xwintab libErosanix fusermountCompat;
    wine = pkgs.wineWow64Packages.staging;
  };

  pinga = pkgs.callPackage ./pinga {
    inherit libErosanix fusermountCompat;
    wine = pkgs.wineWow64Packages.stable;
  };

  pingo = pkgs.callPackage ./pingo {
    wine = pkgs.wineWow64Packages.stable;
  };

  insync-dolphin = pkgs.callPackage ./insync-dolphin {
    ECM = pkgs.kdePackages.extra-cmake-modules;
  };
}
