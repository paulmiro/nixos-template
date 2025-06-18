{
  config,
  lib,
  ...
}:
let
  cfg = config.my-config.openssh;
in
{
  options.my-config.openssh = {
    enable = lib.mkEnableOption "activate openssh";
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
      settings = {
        # we only want to allow authentication via ssh keys, not passwords
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };
}
