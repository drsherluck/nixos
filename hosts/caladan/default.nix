# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  settings.user.wm = "hyprland";
in {
  _module.args = {inherit settings;};
  imports = [
    ./hardware.nix
    ./disko.nix
    ./nvidia.nix
    ../../system/network.nix
    ../../system/keyboard.nix
    ../../system/nix.nix
    # ../../system/nvidia.nix
    ../../system/fonts.nix
    ../../system/docker.nix
    ../../system/ddcutil.nix
    ../../system/bluetooth.nix
    ../../system/amd.nix
    ../../system/chromium-policy.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      devices = ["nodev"];
      useOSProber = false;
    };
  };

  # Base settings
  networking.hostName = "caladan";
  time.timeZone = null;
  services.automatic-timezoned.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true; # screen-sharing
  };

  users.users.danilo = {
    isNormalUser = true;
    initialPassword = "nix";
    uid = 1000;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "i2c"
      "docker"
    ];
  };

  environment.shells = with pkgs; [zsh bash];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  programs.zsh.shellAliases.v = "nvim";

  environment.sessionVariables = {
    EDITOR = "nvim";
    FCEDIT = "nvim";
    NIXOS_FLAKE = "${config.users.users.danilo.home}/nixos";
  };

  # x11
  services.xserver = {
    enable = true;
    autorun = false;
    windowManager.i3.enable = true;
    displayManager = {
      lightdm.enable = lib.mkForce false;
      startx.enable = true;
    };
  };

  # for battery module
  services.upower.enable = true;
  programs.hyprland.enable = true;

  programs.slock.enable = true;

  # programs.light.enable = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = {};
  home-manager = {
    sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
      inputs.catppuccin.homeModules.catppuccin
    ];
    useUserPackages = true;
    useGlobalPkgs = true;
    users.danilo = lib.mkMerge [
      {
        programs.home-manager.enable = true;
        home.stateVersion = config.system.stateVersion;
      }
      (import ../../home/caladan.nix)
    ];
  };

  # home-manager managed xdg.portal
  environment.pathsToLink = ["/share/xdg-desktop-portal" "/share/applications"];

  # avoid the /bin/bash headache
  system.activationScripts.binbash = ''
    mkdir -m 0755 -p /bin
    ln -sfn ${pkgs.bash}/bin/bash /bin/bash
  '';

  environment.systemPackages = with pkgs; [
    neovim
    wget
    curl
    ripgrep
    alejandra # nix formatter
    pulseaudio # pactl
    vulkan-validation-layers # for wlr vulkan
    moreutils
    wireguard-tools
    linuxPackages_latest.cpupower
  ];

  programs.ssh.startAgent = true;
  programs.ssh.agentTimeout = "6h";

  # power management
  services.tlp.enable = false;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
        enable_thresholds = "true";
        start_threshold = "40";
        stop_threshold = "80";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
  systemd.sleep.settings.Sleep = {
    AllowSuspend = "yes";
    AllowHibernation = "yes";
    AllowHybridSleep = "yes";
    AllowSuspendThenHibernate = "yes";
  };
  services.logind.settings.Login = {
    # HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  system.stateVersion = "25.05"; # do not touch
}
