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
    ## steam is an unfree package. uncomment this only if you also uncommented the allowUnfree options
    # programs.steam.enable = true;

    environment.systemPackages = with pkgs; [
      (lutris.override {
        # lutris' steam support requires unfree dependencies.
        # you can remove this option if you're fine with that.
        steamSupport = false;
        extraPkgs = pkgs: [
          # List extra package dependencies here
        ];
        extraLibraries = pkgs: [
          # List extra library dependencies here
        ];
      })
    ];
  };
}
