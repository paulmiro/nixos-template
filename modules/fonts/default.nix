{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my-config.fonts;
in
{
  options.my-config.fonts = {
    enable = lib.mkEnableOption "activate fonts";
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      fontDir.enable = true;

      packages = with pkgs; [
        meslo-lgs-nf
        noto-fonts-emoji
        recursive
      ];

      fontconfig = {
        defaultFonts = {
          serif = [ "Recursive Sans Casual Static Medium" ];
          sansSerif = [ "Recursive Sans Linear Static Medium" ];
          monospace = [ "MesloLGS NF" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
  };
}
