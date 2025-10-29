{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my-config.docker;
in
{
  options.my-config.docker = {
    enable = lib.mkEnableOption "activate docker";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [ "--all" ];
      };
    };

    virtualisation.oci-containers = {
      backend = "docker";
    };

    environment.systemPackages = with pkgs; [ docker-compose ];

    users.extraGroups.docker.members = lib.mkIf config.my-config.user.YOUR-USERNAME-HERE.enable [
      "YOUR-USERNAME-HERE"
    ];

  };
}
