{ self, ... }:
{
  ...
}:
{
  # This file contains a typical server configuration

  my-config = {
    common-server.enable = true;
    systemd-boot.enable = true;

    nginx = {
      enable = true;
      openFirewall = true;
    };

  };

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "example-server";
  };

  services.nginx.virtualHosts."rick.example.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      return = "301 https://www.youtube.com/watch?v=dQw4w9WgXcQ";
    };
  };

  # Running fstrim weekly is a good idea for VMs.
  # Empty blocks are returned to the host, which can then be used for other VMs.
  # It also reduces the size of the qcow2 image, which is good for backups.
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
