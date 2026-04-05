{
  config, pkgs, ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  # https://wiki.hypr.land/Nvidia/#environment-variables
  # https://wiki.hypr.land/Nvidia/#flickering-in-electron--cef-apps
  # https://wiki.hypr.land/Nvidia/#va-api-hardware-video-acceleration
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    ELECTRON_OZON_PLATFORM_HINT = "auto";
    NVD_BACKEND = "direct";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.systemPackages = with pkgs; [
    egl-wayland
  ];
}
