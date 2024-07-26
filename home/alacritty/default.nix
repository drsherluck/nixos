{lib, ...}: {
  programs.alacritty.enable = true;
  programs.alacritty.settings = lib.importTOML ./alacritty.toml;
}
