{
  config,
  lib,
  ...
}:
{
  options = {
    my-config.nixpkgs-config.enable = lib.mkEnableOption "nixpkgs config";
  };

  config = lib.mkIf config.my-config.nixpkgs-config.enable {
    nixpkgs.config = import ./nixpkgs-config.nix;
    xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;
  };
}
