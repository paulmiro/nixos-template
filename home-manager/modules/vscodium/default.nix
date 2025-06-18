{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my-config.programs.vscode;
in
{
  options.my-config.programs.vscode = {
    enable = lib.mkEnableOption "enable vscode";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;

      ### Below are some hints to how you can configure your editor
      ### if you set anything here, you cannot edit your vscode configuration manually from the UI.

      # https://rycee.gitlab.io/home-manager/options.xhtml#opt-programs.vscode.keybindings
      # keybindings = [ ];

      # ~/.config/Code/User/settings.json
      # userSettings = {
      # };

      # extensions = with pkgs.vscode-extensions; [
      # ];
    };
  };
}
