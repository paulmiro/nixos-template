{
  config,
  lib,
  ...
}:
let
  cfg = config.my-config.programs.ssh;
in
{
  options.my-config.programs.ssh = {
    enable = lib.mkEnableOption "enable ssh";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      # this option is deprecated and will be removed in the future, that's why we set the defaults manually below
      enableDefaultConfig = false;
      matchBlocks = {
        # each entry here becomes a "Host" entry in ~/.ssh/config
        "*" = {
          # these options are the defaults
          forwardAgent = false;
          addKeysToAgent = "no";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
        };
        "gh" = {
          hostname = "github.com";
          user = "git";
        };
      };
    };
  };
}
