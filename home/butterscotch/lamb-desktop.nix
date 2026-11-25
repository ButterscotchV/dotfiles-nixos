{
  pkgs,
  pkgsFast,
  ...
}:

{
  home.packages = with pkgs; [
    # === VR ===
    wayvr

    # === VRChat ===
    # https://github.com/NixOS/nixpkgs/issues/570938
    pkgsFast.alcom
    unityhub
    vrcx
  ];

  programs.git.signing = {
    key = "6787CAC34691043E";
    signByDefault = true;
  };
}
