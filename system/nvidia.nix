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

  environment.sessionVariables =
    if open
    then {}
    else {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_VRR_ALLOWED = "0";
      __GL_GSYNC_ALLOWED = "0";
      # https://www.reddit.com/r/swaywm/comments/11d89w2/some_workarounds_to_use_sway_with_nvidia/
      WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDERER = "vulkan";
      XWAYLAND_NO_GLAMOR = "1";
      # https://wiki.hyprland.org/Nvidia/#fixing-random-flickering-method-1
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [vaapiVdpau];
  };

  hardware.nvidia = {
    inherit open;
    modesetting.enable = true;
    powerManagement.enable = lib.mkDefault false;
    nvidiaSettings = true;
  };
}
