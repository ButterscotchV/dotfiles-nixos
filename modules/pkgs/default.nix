{
  pkgs,
  libErosanix,
  ...
}:

let
  xwintab = pkgs.callPackage ./xwintab { };
in
{
  aternos-thanos = pkgs.callPackage ./aternos-thanos { };

  rebelle7 = pkgs.callPackage ./rebelle {
    inherit xwintab libErosanix;
    wine = pkgs.wineWow64Packages.staging;
    sourceVersion = {
      major = "7";
      minor = "2";
      patch = "8";
      suffix = "";
    };
    hash = "sha256-hfuhaHZhITNWpurAhVOREE/EXZAzSLLHLK6P61BCT6c=";
  };

  rebelle8 = pkgs.callPackage ./rebelle {
    inherit xwintab libErosanix;
    wine = pkgs.wineWow64Packages.staging;
    sourceVersion = {
      major = "8";
      minor = "4";
      patch = "0";
      suffix = "";
    };
    hash = "sha256-ETMZXIdZFK0PAyFQDRVvskWzY+lyx5R9uqU/IgpVeNk=";
  };

  rebelle-thumbnailer = pkgs.callPackage ./rebelle-thumbnailer { };

  pinga = pkgs.callPackage ./pinga {
    inherit libErosanix;
    wine = pkgs.wineWow64Packages.stable;
  };

  pingo = pkgs.callPackage ./pingo {
    wine = pkgs.wineWow64Packages.stable;
  };

  insync-dolphin = pkgs.callPackage ./insync-dolphin {
    ECM = pkgs.kdePackages.extra-cmake-modules;
  };
}
