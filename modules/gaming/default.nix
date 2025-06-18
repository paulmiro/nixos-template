{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my-config.gaming;
in
{
  options.my-config.gaming = {
    enable = lib.mkEnableOption "activate gaming programs and options";
  };

  config = lib.mkIf cfg.enable {
    ## TODO: uncomment this only if you also uncommented the allowUnfree options

    # programs.steam.enable = true;
    # environment.systemPackages = with pkgs; [
    #   (lutris.override {
    #     extraPkgs = pkgs: [
    #       # List package dependencies here
    #     ];
    #     extraLibraries = pkgs: [
    #       # List library dependencies here
    #     ];
    #   })
    # ];
  };
}
