{
  config,
  lib,
  ...
}:
let
  cfg = config.my-config.nginx;
in
{
  options.my-config.nginx = with lib; {
    enable = mkEnableOption "activate nginx";

    openFirewall = mkEnableOption "open port 80 and 443";

    defaultDomain = mkOption {
      type = types.str;
      default = null;
      description = "The fallback domain to use for the nginx configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    ## enable the NGINX web server and reverse proxy

    services.nginx = {
      enable = true;
      clientMaxBodySize = "8196m"; # 8GiB, fixes some issues with services that require large file uploads
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts = lib.mkIf (cfg.defaultDomain != null) {
        ${cfg.defaultDomain} = {
          default = true; # redirect all traffic not matched by other VirtualHosts here
          enableACME = lib.mkIf cfg.openFirewall true; # ACME fails with closed firewall
          forceSSL = lib.mkIf cfg.openFirewall true; # turn off SSL if we don't have a cert
          locations."/" = {
            return = "418"; # I'm a teapot
          };
        };
      };
    };

    # security.acme.defaults.email = "example@example.com"; # TODO: add an email address for letsencrypt
    # security.acme.acceptTerms = true; # TODO: uncomment to accept letsencrypt terms of service

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      80
      443
    ];
  };
}
