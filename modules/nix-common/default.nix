{
  config,
  lib,
  nixpkgs,
  pkgs,
  ...
}:
let
  cfg = config.my-config.nix-common;
in
{
  options.my-config.nix-common = {
    enable = lib.mkEnableOption "activate nix-common";
    disable-cache = lib.mkEnableOption "not use binary-cache";
  };

  config = lib.mkIf cfg.enable {

    nixpkgs = {
      overlays = [ ];
      config = import ./nixpkgs-config.nix;
    };

    nix = {
      package = pkgs.nixVersions.stable;
      nixPath = [ "nixpkgs=${nixpkgs}" ];
      registry.nixpkgs.flake = nixpkgs;

      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        substituters = lib.mkIf (cfg.disable-cache != true) [
          # chache.nixos.org has priority=40
          ## uncomment this line (and the key below) to allow using the binary cache for nix-community projects
          # "https://nix-community.cachix.org/?priority=70"
        ];

        trusted-public-keys = lib.mkIf (cfg.disable-cache != true) [
          # "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];

        connect-timeout = 5;

        builders-use-substitutes = true;

        fallback = true;

        trusted-users = [
          "root"
          "@wheel"
        ];

        log-lines = 25;

        # Save space by hardlinking store files
        auto-optimise-store = true;

        min-free = (512 * 1024 * 1024);
        max-free = (2048 * 1024 * 1024);
      };

      # Clean up old generations after 30 days
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };

      # nix can sometimes make your desktop unresponsive. This is a workaround for that issue
      daemonCPUSchedPolicy = if config.my-config.common-desktop.enable then "idle" else "batch";
      daemonIOSchedClass = lib.mkDefault "idle";
      daemonIOSchedPriority = lib.mkDefault 7;
    };

    # This script will show you a diff for the installed packages on every rebuild
    system.activationScripts.diff = {
      supportsDryActivation = true;
      text = ''
        if [[ -e /run/current-system ]]; then
          echo "--- diff to current-system"
          ${pkgs.nvd}/bin/nvd --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig"
          echo "---"
        fi
      '';
    };
  };
}
