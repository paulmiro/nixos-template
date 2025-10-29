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
      settings = {
        # TODO: set your git name and email here
        user.name = "Example Name";
        user.email = "example@example.com";

        init.defaultBranch = "main";

        # these options change the default behavior of git. I like them, you may not.
        # pull.rebase = true;
        # rebase.autostatsh = true;
        # merge.autostatsh = true;
      };
    };

    home.packages = with pkgs; [
      # pre-commit
    ];

  };
}
