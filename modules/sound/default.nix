{
  config,
  lib,
  ...
}:
let
  cfg = config.my-config.sound;
in
{
  options.my-config.sound = {
    enable = lib.mkEnableOption "activate sound";
  };

  config = lib.mkIf cfg.enable {
    ## audio on linux is a mess.
    ## this module shloud make it "just work"

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };
}
