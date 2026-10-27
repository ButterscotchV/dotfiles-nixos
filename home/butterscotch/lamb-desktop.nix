{
  pkgs,
  pkgsStable,
  ...
}:

{
  home.packages = with pkgs; [
    # === File management/sync ===
    # https://github.com/NixOS/nixpkgs/issues/576779
    pkgsStable.insync

    # === VR ===
    wayvr

    # === VRChat ===
    alcom
    unityhub
    vrcx
  ];

  programs.git.signing = {
    key = "6787CAC34691043E";
    signByDefault = true;
  };
}
