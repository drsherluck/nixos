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
  settings.user.wm = "test";
in {
  _module.args = {inherit settings;};
  imports = [
    ./hardware.nix
    ./disko.nix
    ../../system/network.nix
    ../../system/keyboard.nix
    ../../system/nix.nix
    ../../system/nvidia.nix
    ../../system/fonts.nix
    ../../system/docker.nix
    ../../system/ddcutil.nix
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      devices = ["nodev"];
      useOSProber = true;
    };
  };

  # Base settings
  networking.hostName = "arrakis";
  time.timeZone = "Europe/Amsterdam";
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
    # NIXOS_OZONE_WL = "1";
    # https://www.reddit.com/r/swaywm/comments/11d89w2/some_workarounds_to_use_sway_with_nvidia/
    # WLR_NO_HARDWARE_CURSORS = "1";
    # WLR_RENDERER = "vulkan";
    # XWAYLAND_NO_GLAMOR = "1";
    # https://wiki.hyprland.org/Nvidia/#fixing-random-flickering-method-1
    # ELECTRON_OZONE_PLATFORM_HINT = "auto";
    # general wayland
    # QT_QPA_PLATFORM = "wayland";
    # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
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

  programs.light.enable = true;
  security.polkit.enable = true;
  #security.pam.services.swaylock = {};

  home-manager = {
    sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
      inputs.catppuccin.homeManagerModules.catppuccin
    ];
    useUserPackages = true;
    useGlobalPkgs = true;
    users.danilo = lib.mkMerge [
      {
        programs.home-manager.enable = true;
        home.stateVersion = config.system.stateVersion;
      }
      (import ../../home/personal.nix)
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
  ];

  programs.ssh.startAgent = true;
  programs.ssh.agentTimeout = "6h";

  system.stateVersion = "23.11"; # do not touch
}
