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
    powerManagement.enable = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "550.142";
      sha256_64bit = "sha256-bdVJivBLQtlSU7Zre9oVCeAbAk0s10WYPU3Sn+sXkqE=";
      sha256_aarch64 = "sha256-sBp5fcCPMrfrTZTF1FqKo9g0wOWP+5+wOwQ7PLWI6wA=";
      openSha256 = "sha256-hjpwTR4I0MM5dEjQn7MKM3RY1a4Mt6a61Ii9KW2KbiY=";
      settingsSha256 = "sha256-Wk6IlVvs23cB4s0aMeZzSvbOQqB1RnxGMv3HkKBoIgY=";
      persistencedSha256 = "ssha256-yQFrVk4i2dwReN0XoplkJ++iA1WFhnIkP7ns4ORmkFA=";
    };
  };
}
