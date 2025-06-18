{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my-config.user.YOUR-USERNAME-HERE;
in
{
  options.my-config.user.YOUR-USERNAME-HERE = {
    enable = lib.mkEnableOption "activate user YOUR-USERNAME-HERE";
  };

  config = lib.mkIf cfg.enable {
    # TODO: find and replace every instance of "YOUR-USERNAME-HERE" in this repo with your username, including this file's name
    # changing your username is very hard to do, so choose wisely
    # if you have installed NixOS with the default installer, you will have set a username there. Be sure to use the same one here
    users.users.YOUR-USERNAME-HERE = {
      isNormalUser = true;
      # description = "Max Mustermann"; # TODO set your display name here
      extraGroups = [
        "wheel"
        (lib.mkIf config.networking.networkmanager.enable "networkmanager")
      ];
      shell = lib.mkIf config.programs.zsh.enable pkgs.zsh;
      ## TODO: either set a password with ‘passwd’ immediately after installing, or, if you understand the implications, set a hashed password below
      ## if you used the graphical installer you probably set a password from there and don't need to do this
      # initialHashedPassword = "YOUR-HASHED-PASSWORD-HERE";
      ## This looks stupid but does the job if you want your own user to trust the same ssh public keys as the root user
      # openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;
    };

    nix.settings = {
      allowed-users = [ "YOUR-USERNAME-HERE" ];
    };
  };
}
