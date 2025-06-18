{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my-config.nvidia;
in
{
  ### WARNING: enabling this module may drastically prolong build times

  options.my-config.nvidia = {
    enable = lib.mkEnableOption "activate nvidia";
  };

  config = lib.mkIf cfg.enable {
    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    environment.systemPackages = with pkgs; [ nvtopPackages.full ];

    hardware = {
      # Enable OpenGL
      graphics = {
        enable = true;
        enable32Bit = true;
      };

      nvidia = {
        ## Fine-grained power management. Turns off GPU when not in use.
        ## Experimental and only works on modern Nvidia GPUs (Turing or newer).
        # powerManagement.finegrained = false;

        ## Use the NVidia open source kernel module (not to be confused with the
        ## independent third-party "nouveau" open source driver).
        ## Support is limited to the Turing and later architectures. Full list of
        ## supported GPUs is at:
        ## https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
        ## Only available from driver 515.43.04+
        ## Do not disable this unless your GPU is unsupported or if you have a good reason to.
        open = true;

        ## Enable the Nvidia settings menu,
        ## accessible via `nvidia-settings`.
        # nvidiaSettings = true;

        ## Optionally, you may need to select the appropriate driver version for your specific GPU.
        # package = config.boot.kernelPackages.nvidiaPackages.beta;
      };

      nvidia-container-toolkit.enable = lib.mkIf config.virtualisation.docker.enable true;
    };
  };
}
