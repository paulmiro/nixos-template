{
  config,
  home-manager,
  lib,
  ...
}:
let
  cfg = config.my-config.common-desktop;
in
{
  imports = [
    home-manager.nixosModules.home-manager
  ];

  options.my-config.common-desktop = {
    enable = lib.mkEnableOption "contains configuration that is common to all systems with a desktop environment";
  };

  config = lib.mkIf cfg.enable {
    my-config = {
      common.enable = true;

      home-manager.profile = "desktop";

      sound.enable = true;
      fonts.enable = true;
      gnome.enable = true;
      # gaming.enable = true;
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;
  };
}
