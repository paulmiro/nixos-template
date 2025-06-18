{ self, ... }:
{
  lib,
  modulesPath,
  nixos-hardware,
  ...
}:
{

  my-config = {
    common-server.enable = true;
  };

  imports = [
    # being able to build the sd-image
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"

    # https://github.com/NixOS/nixos-hardware/tree/master/raspberry-pi/4
    nixos-hardware.nixosModules.raspberry-pi-4
  ];

  # nix build .\#nixosConfigurations.pi4b.config.system.build.sdImage
  # add boot.binfmt.emulatedSystems = [ "aarch64-linux" ]; to your x86 system
  # to be able to build ARM stuff through qemu
  sdImage.compressImage = false;
  sdImage.imageBaseName = "raspi-image";

  networking = {
    hostName = "pi4b-example";
    networkmanager.enable = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
