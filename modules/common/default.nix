{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my-config.common;
in
{
  options.my-config.common = {
    enable = lib.mkEnableOption "contains configuration that is common to all systems";
  };

  config = lib.mkIf cfg.enable {
    my-config = {
      home-manager.enable = true;

      nix-common.enable = true;
      openssh.enable = true;
      user = {
        YOUR-USERNAME-HERE.enable = true;
        root.enable = true;
      };
    };

    programs.zsh.enable = true;
  };
}
