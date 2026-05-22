{
  pkgs,
  inputs,
  ...
}: {
  fonts.packages = with pkgs; [
    openmoji-color
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-lgc-plus
    nerd-fonts.inconsolata
    vista-fonts
    mononoki
    aileron
    atkinson-hyperlegible
    lato
    libertinus
    ibm-plex
    newcomputermodern
    inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-mono-nerd
    inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-pro-nerd
    (callPackage ../pkgs/consolas-nerd-font.nix {})
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = ["Consolas"];
    defaultFonts.emoji = ["OpenMoji Color"];
  };
}
