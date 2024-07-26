{
  pkgs,
  lib,
  ...
}: {
  programs.fastfetch = {
    enable = true;
    settings = lib.importJSON ./simple.jsonc;
    package = pkgs.fastfetch;
  };

  xdg.dataFile."fastfetch/nixos.txt".source = ./nixos.txt;
}
