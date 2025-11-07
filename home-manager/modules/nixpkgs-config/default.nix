{
  config,
  lib,
  ...
}:
let
  cfg = config.my-config.nixpkgs-config;
  path = ./../../../modules/nix-common/nixpkgs-config.nix;
in
{
  options.my-config.nixpkgs-config = {
    enable = lib.mkEnableOption "nixpkgs config";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config = import path;
    xdg.configFile."nixpkgs/config.nix".source = ./../../../modules/nix-common/nixpkgs-config.nix;
  };
}
