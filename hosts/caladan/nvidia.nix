{
  config,
  pkgs,
  lib,
  ...
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
    # CUDA_DISABLE_PERF_BOOST = "1";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # nvidia-vaapi-driver (chromium not supprotedD)
      libva-vdpau-driver
    ];
  };

  boot.kernelParams = [
    "nvidia_drm.fbdev=1"
    "nvidia-drm.modeset=1"
    # "module_blacklist=i915"
  ];

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    prime = {
      offload = {
        enable = lib.mkOverride 990 true;
        enableOffloadCmd = true;
      };
      sync.enable = false;
      nvidiaBusId = "PCI:100:0:0";
      amdgpuBusId = "PCI:101:0:0";
    };
  };

  environment.systemPackages = with pkgs; [
    egl-wayland
    libva-utils
    wgpu-utils
    libglvnd
    libvpx
    vdpauinfo
    nvtopPackages.full
  ];
}
