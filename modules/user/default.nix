{ pkgs, pkgsLocal, ... }:

{
  imports = [
    ./cache/default.nix
    ./gaming/steam.nix
    ./peripherals/mouse.nix
    ./peripherals/printer.nix
    ./peripherals/rgb.nix
  ];

  # User configuration
  users.users.butterscotch = {
    isNormalUser = true;
    description = "Butterscotch!";
    extraGroups = [
      "audio"
      "dialout"
      "docker"
      "gamemode"
      "networkmanager"
      "video"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    bitwarden-desktop
    pkgsLocal.rebelle-thumbnailer
  ];

  # Macro software
  services.crossmacro = {
    enable = true;
    users = [ "butterscotch" ];
  };
}
