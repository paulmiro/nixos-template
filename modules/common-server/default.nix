{
  config,
  lib,
  ...
}:
let
  cfg = config.my-config.common-server;
in
{
  options.my-config.common-server = {
    enable = lib.mkEnableOption "contains configuration that is common to all server machines";
  };

  config = lib.mkIf cfg.enable {
    my-config = {
      common.enable = true;

      home-manager.profile = "server";
    };
  };
}
