{
  config,
  lib,
  ...
}:
let
  cfg = config.my-config.programs.ssh;
in
{
  options.my-config.programs.ssh = {
    enable = lib.mkEnableOption "enable ssh";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      matchBlocks = {
        # each entry here becomes a "Host" entry in ~/.ssh/config
        "gh" = {
          hostname = "github.com";
          user = "git";
        };
      };
    };
  };
}
