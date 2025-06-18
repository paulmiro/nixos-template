{
  pkgs,
  ...
}:
{
  config = {
    my-config = {
      # programs.direnv.enable = true;
    };

    home.packages = with pkgs; [
    ];
  };
}
