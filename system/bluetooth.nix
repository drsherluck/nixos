{config, ...}: {
  # https://nixos.wiki/wiki/Bluetooth#Bluetooth_fails_to_power_on_with_Failed_to_set_power_on:_org.bluez.Error.Blocked
  services.blueman.enable = true;

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Experimental = "true";
        # ControllerMode = "bredr";
      };
    };
  };

  # xbox wireless controller support
  hardware.xpadneo.enable = true;

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [xpadneo];
    extraModprobeConfig = ''
      options bluetooth disable_ertm=1
    '';
  };

  services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
    "monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = true;
      "bluez5.enable-hw-volume" = true;
      "bluez5.roles" = ["a2dp_sink" "a2dp_source" "bap_sink" "bap_source" "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag"];
    };
  };
}
