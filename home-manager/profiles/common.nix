{
  pkgs,
  ...
}:
{
  config = {

    my-config = {
      programs.git.enable = true;
      programs.ssh.enable = true;
      programs.zsh.enable = true;
      nixpkgs-config.enable = true;
    };

    # Home-manager nixpkgs config
    nixpkgs = {
      overlays = [ ];
    };

    # Include man-pages
    manual.manpages.enable = true;

    # Install these packages for my user
    home.packages = with pkgs; [
      # dnsutils
      # glances
      # nix-tree
      # nixfmt-rfc-style
      # openssl
      # ripgrep
      # tmux
      # usbutils
      wget
      # zellij
    ];

    # Let Home Manager install and manage itself
    programs.home-manager.enable = true;

    ### 🚧 Do NOT change this value 🚧
    home.stateVersion = "25.11";
  };
}
