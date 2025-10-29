{
  pkgs,
  ...
}:
{
  config = {
    my-config = {
      # programs.vscode.enable = true;
      # programs.direnv.enable = true;
    };

    programs = {
      firefox = {
        enable = true;
        package = (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) { });
      };
    };

    # Install these packages for my user
    home.packages = with pkgs; [
      # audacity
      # element-desktop
      # libreoffice
      # mpv
      # obsidian
      # signal-desktop
      # thunderbird-bin
    ];
  };
}
