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
      config = {
        global = {
          hide_env_diff = true;
        };
      };
    };

    # uncomment this ONLY if you want to manage vscode's extensions declaratively.
    # if you wan to manage vscode extensions imperatively, simply install the mkhl.direnv extension manually.
    # programs.vscode = {
    #   extensions = with pkgs.vscode-extensions; [ mkhl.direnv ];
    # };

    # this causes direnv to store it's cache under ~/.cache/direnv/... instead of ./.direnv
    # this has the benefit of not having to add ".direnv" to .gitignore and prevents IDEs from indexing the directory
    xdg.configFile."direnv/direnvrc".text = ''
      # Set cache dir
      : "''${XDG_CACHE_HOME:="''${HOME}/.cache"}"
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          local hash path
          echo "''${direnv_layout_dirs[$PWD]:=$(
              hash="$(sha1sum - <<< "$PWD" | head -c40)"
              path="''${PWD//[^a-zA-Z0-9]/-}"
              echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
          )}"
      }
    '';

  };
}
