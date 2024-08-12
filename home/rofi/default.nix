{lib, ...}: {
  programs.rofi = {
    enable = true;
    theme = lib.mkForce ./theme.rasi;
  };
}
