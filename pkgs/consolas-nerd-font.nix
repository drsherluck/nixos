{
  lib,
  stdenvNoCC,
  vistafonts,
  python3Packages,
  fetchzip,
}:
# see https://dee.underscore.world/blog/home-manager-fonts/
let
  version = "3.2.1";
in
  stdenvNoCC.mkDerivation {
    version = "3.2.1";
    pname = "consolas-nerd-font";

    src = fetchzip {
      url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/FontPatcher.zip";
      stripRoot = false;
      hash = "sha256-3s0vcRiNA/pQrViYMwU2nnkLUNUcqXja/jTWO49x3BU=";
    };

    nativeBuildInputs = with python3Packages; [
      python
      fontforge
    ];

    buildPhase = ''
      mkdir -p $out/share/fonts/truetype/NerdFonts
      for f in ${vistafonts}/share/fonts/truetype/consola*; do
        python font-patcher $f --complete --no-progressbars --outputdir $out/share/fonts/truetype/NerdFonts
      done
    '';

    dontInstall = true;
    dontFixup = true;

    meta = with lib; {
      homepage = "https://github.com/ryanoasis/nerd-fonts";
      description = "Microsoft Windows Vista Consolas font patched with nerd font icons";
      license = licenses.unfree;
      platforms = platforms.all;
    };
  }
