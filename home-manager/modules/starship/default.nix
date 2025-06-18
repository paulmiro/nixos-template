{
  config,
  lib,
  ...
}:
let
  cfg = config.my-config.programs.starship;
in
{
  options.my-config.programs.starship = {
    enable = lib.mkEnableOption "enable starship";
  };

  config = lib.mkIf cfg.enable {
    # Starship is a pretty, modern and fast shell prompt
    programs.starship = {
      enable = true;
      settings = {
        hostname = {
          format = "[$hostname]($style) ";
        };
        username = {
          format = "[$user]($style)@";
        };
        directory = {
          truncation_length = 10;
          truncation_symbol = "⋯/";
        };
      };
    };
  };
}
