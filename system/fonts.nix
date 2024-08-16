{pkgs, ...}: {
  fonts.packages = with pkgs; [
    openmoji-color
    noto-fonts
    noto-fonts-cjk
    noto-fonts-lgc-plus
    inconsolata-nerdfont
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
