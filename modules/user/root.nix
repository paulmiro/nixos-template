{
  config,
  lib,
  ...
}:
let
  cfg = config.my-config.user.root;
in
{
  options.my-config.user.root = {
    enable = lib.mkEnableOption "activate user root";
  };

  config = lib.mkIf cfg.enable {
    users.users.root = {
      openssh.authorizedKeys.keys = [
        # TODO: add your trusted ssh keys here
        # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM///////////////NOT+A+REAL+KEY///////////// user@host"
      ];
    };
  };
}
