{
  config,
  lib,
  ...
}:
let
  cfg = config.my-config.nixpkgs-config;
  nixpkgs-config = import ./../../../modules/nix-common/nixpkgs-config.nix; # this makes sure we share the config between home-manager and nixos
in
{
  options.my-config.nixpkgs-config = {
    enable = lib.mkEnableOption "nixpkgs config";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config = nixpkgs-config;
    xdg.configFile."nixpkgs/config.nix".source = config.my-config.nixpkgs-config.path;
  };
}
