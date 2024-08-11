{
  pkgs,
  lib,
  ...
}: {
  boot.initrd.kernelModules = ["amdgpu"];
  # sea islands cards (make vulkan work)
  # boot.kernelParams = ["radeon.cik_support=0" "amdgpu.cik_support=1"];
  services.xserver.videoDrivers = lib.mkDefault ["amdgpu"];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [vaapiVdpau];
  };

  hardware.amdgpu.amdvlk = {
    enable = true;
    support32Bit.enable = true;
  };
}
