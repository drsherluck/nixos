{
  config,
  pkgs,
  lib,
  settings,
  ...
}: let
  open = settings.user.wm == "sway";
  driver =
    if open
    then "nouveau"
    else "nvidia";
in {
  services.xserver.videoDrivers = lib.mkDefault ["${driver}"];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __GL_VRR_ALLOWED = "0";
    __GL_GSYNC_ALLOWED = "0";
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [vaapiVdpau];
  };

  hardware.nvidia = {
    inherit open;
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
