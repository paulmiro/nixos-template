{
  config,
  lib,
  ...
}:
let
  cfg = config.my-config.grub;
in
{
  options.my-config.grub = {
    enable = lib.mkEnableOption "activate grub";
  };

  config = lib.mkIf cfg.enable {
    ## enable the GRUB bootloader
    boot = {
      loader = {
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          efiInstallAsRemovable = true;
          useOSProber = true;
          # Maximum number of latest generations in the boot menu.
          # Useful to prevent boot partition running out of disk space.
          # if you get errors about "not enough space on device" when rebuilding, you will want to turn this down
          configurationLimit = 20;
        };
      };
      tmp.cleanOnBoot = true;
    };
  };
}
