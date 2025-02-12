{pkgs, ...}: {
  fonts.packages = with pkgs; [
    openmoji-color
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-lgc-plus
    nerd-fonts.inconsolata
    vistafonts
    mononoki
    aileron
    atkinson-hyperlegible
    lato
    (callPackage ../pkgs/consolas-nerd-font.nix {})
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = ["Consolas"];
    defaultFonts.emoji = ["OpenMoji Color"];
  };
}
