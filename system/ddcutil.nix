{
  pkgs,
  config,
  lib,
  ...
}: let
  ddcbright = pkgs.writeScriptBin "ddcbright" ''
    #!/usr/bin/env bash
    num=$(xrandr --listactivemonitors | rg "^Monitors: ([0-9]+)$" -r '$1')
    printf '%s\n' $(seq 1 $num) | xargs -I% -P1 ddcutil setvcp --mccs=2.2 --noconfig --noverify -d % 10 "$@" > /dev/null
  '';
in {
  hardware.i2c.enable = true;
  environment.systemPackages = with pkgs; [
    ddcutil
    ripgrep
    ddcbright
  ];

  # https://www.ddcutil.com/nvidia/
  boot.extraModprobeConfig = lib.mkIf (config.hardware.nvidia.modesetting.enable) ''
    options nvidia NVreg_RegistryDwords=RMUseSwI2c=0x01;RMI2cSpeed=100
  '';
}
