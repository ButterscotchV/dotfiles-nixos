{ ... }:

{
  services.udev.extraFiles = [
    ./69-slimevr-devices.rules
  ];
  # Tracker server: 6969/UDP
  # Tracker OTA server: 8266/UDP/TCP
  # GUI: 21110/TCP (local)
  networking.firewall = {
    allowedUDPPorts = [
      6969
      8266
    ];
    allowedTCPPorts = [
      8266
    ];
  };
}
