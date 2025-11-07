{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my-config.programs.zsh;
in
{
  options.my-config.programs.zsh = {
    enable = lib.mkEnableOption "enable zsh configuration";
  };

  config = lib.mkIf cfg.enable {
    my-config.programs.starship.enable = true;

    home.shell.enableZshIntegration = true;

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      dotDir = "${config.xdg.configHome}/zsh";

      sessionVariables = {
        ZDOTDIR = "${config.xdg.configHome}/zsh";
      };

      initContent = ''
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
      '';

      history = {
        expireDuplicatesFirst = true;
        ignoreSpace = false;
        save = 15000;
        share = true;
      };

      plugins = [
        {
          name = "fast-syntax-highlighting";
          file = "fast-syntax-highlighting.plugin.zsh";
          src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting";
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
        }
      ];

      shellAliases = {
        ### Nix

        ## always execute nixos-rebuild with sudo for switching (will ask for your password after building)
        # nixos-rebuild = "${pkgs.nixos-rebuild}/bin/nixos-rebuild --sudo";

        ## switching within a flake repository
        # frb = "${pkgs.nixos-rebuild}/bin/nixos-rebuild --sudo switch --flake .";

        ## nix-shell
        # ns = "nix-shell -p";

        ### Systemd

        ## show journalctl logs for a service
        # logs = "${pkgs.systemd}/bin/journalctl -feau";

        ### Important

        ## uncomment this line for a friendlier shell experience
        # please = "sudo";

        "ßh" = "ssh";
      };
    };

    programs = {
      ## Colors for ls
      # dircolors.enable = true;

      ## superpowers for cd
      # zoxide = {
      #   enable = true;
      #   options = [ "--cmd cd" ];
      # };
    };
  };
}
