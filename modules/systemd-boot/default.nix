{
  config,
  lib,
  ...
}:
let
  cfg = config.my-config.systemd-boot;
in
{
  options.my-config.systemd-boot = {
    enable = lib.mkEnableOption "activate systemd-boot";
  };

  config = lib.mkIf cfg.enable {
    # Use systemd-boot as the bootloader.
    boot.loader.systemd-boot.enable = true;
    # Whether the installation process is allowed to modify EFI boot variables.
    boot.loader.efi.canTouchEfiVariables = true;
    # Maximum number of latest generations in the boot menu.
    # Useful to prevent boot partition running out of disk space.
    # if you get errors about "not enough space on device" when rebuilding, you will want to turn this down
    boot.loader.systemd-boot.configurationLimit = 20;
    # Why not have memtest86 ready to go?
    boot.loader.systemd-boot.memtest86.enable = true;
  };
}
