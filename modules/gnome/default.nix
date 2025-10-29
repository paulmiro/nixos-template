{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my-config.gnome;
in
{
  options.my-config.gnome = {
    enable = lib.mkEnableOption "activate gnome";
  };

  config = lib.mkIf cfg.enable {
    # Enable the GNOME Desktop Environment.
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # Enable the X11 windowing system.
    # GNOME will still run on wayland by default
    services.xserver.enable = true;

    environment.gnome.excludePackages = with pkgs; [
      atomix # puzzle game
      epiphany # web browser
      geary # email client
      gnome-initial-setup
      gnome-music
      gnome-photos
      gnome-tour
      hitori # sudoku game
      iagno # go game
      tali # poker game
      yelp # gnome help
    ];

    programs.dconf.enable = true;

    environment.systemPackages = with pkgs; [
      gnome-tweaks
    ];
  };
}
