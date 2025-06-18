{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my-config.programs.git;
in
{
  options.my-config.programs.git = {
    enable = lib.mkEnableOption "enable git";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      lfs.enable = true;
      extraConfig = {
        # pull.rebase = true; # uncomment this if you are a merge commit hater
        init.defaultBranch = "main";
      };
      # userEmail = "example@example.com"; # TODO: set your git userEmail
      # userName = "Example Musterperson"; # TODO: set your git userName
    };

    home.packages = with pkgs; [
      # pre-commit
    ];

  };
}
