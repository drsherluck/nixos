# The NixOS catppuccin module is imported for every host (flake.nix sharedModules),
# but theming is done per-user in home/core.nix — no system-wide port is enabled.
# Set both toggles explicitly: catppuccin/nix warns until `autoEnable` is defined,
# because it is about to become the auto-enrolment switch and `enable` a global
# on/off toggle.
{
  catppuccin = {
    enable = false;
    autoEnable = false;
  };
}
