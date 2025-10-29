{
  config,
  lib,
  ...
}:
let
  cfg = config.my-config.nginx;
in
{
  options.my-config.nginx = {
    enable = lib.mkEnableOption "activate nginx";

    openFirewall = lib.mkEnableOption "open port 80 and 443";

    defaultDomain = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The fallback domain to use for the nginx configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    ## enable the NGINX web server and reverse proxy

    services.nginx = {
      enable = true;
      clientMaxBodySize = "8196m"; # 8GiB, fixes some issues with services that require large file uploads

      recommendedBrotliSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      # send access logs to the systemd journal instead of /var/log/nginx/access.log
      commonHttpConfig = ''
        access_log syslog:server=unix:/dev/log;
      '';

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

    ## some parts of this template repostory will break without this.
    ## if you don't want to accept the letsencrpt TOS, just remove all occurences of "enableACME = true;" and "forceSSL = true;"
    # security.acme.defaults.email = "example@example.com"; # TODO: add an email address for letsencrypt
    # security.acme.acceptTerms = true; # TODO: uncomment to accept letsencrypt terms of service

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      80
      443
    ];
  };
}
