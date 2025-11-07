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

    # https://github.com/NixOS/nixos-hardware/tree/master/raspberry-pi/3
    nixos-hardware.nixosModules.raspberry-pi-3
  ];

  # nix build .\#nixosConfigurations.pi3a.config.system.build.sdImage
  # add boot.binfmt.emulatedSystems = [ "aarch64-linux" ]; to your x86 system
  # to be able to build ARM stuff through qemu
  sdImage.compressImage = false;
  sdImage.imageBaseName = "raspi-image";

  networking = {
    hostName = "example-pi3a";
    networkmanager.enable = true;
  };

  boot.supportedFilesystems = {
    zfs = false; # the zfs kernel package for aarch64 is not cached
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
