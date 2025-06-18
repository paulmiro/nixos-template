{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my-config.programs.direnv;
in
{
  options.my-config.programs.direnv = {
    enable = lib.mkEnableOption "activate direnv";
  };

  config = lib.mkIf cfg.enable {
    # direnv allows you to load and unload environment variables depending on the current directory
    # it plays very nicely with nix shells
    # https://direnv.net/
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      # enableFishIntegration = true;
      # enableNushellIntegration = true;
      nix-direnv.enable = true;
    };

    # programs.vscode = {
    #   extensions = with pkgs.vscode-extensions; [ mkhl.direnv ];
    # };

  };
}
