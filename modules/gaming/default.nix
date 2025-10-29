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
      # lutris usually depends on some unfree software, but the lutris-free package has these dependencies removed
      # if you're fine with using unfree dependencies, you can replace "lutrsis-free" with "lutris" here
      (lutris-free.override {
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
