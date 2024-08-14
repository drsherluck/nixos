{
  stdenv,
  bash,
  curl,
  makeWrapper,
  lib,
}:
stdenv.mkDerivation {
  name = "unbound-rules";
  src = ./unbound.sh;
  buildInputs = [bash curl];
  nativeBuildInputs = [makeWrapper];
  unpackPhase = ''
    cp $src $(stripHash $src);
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp unbound.sh $out/bin/unbound-rules
    chmod +x $out/bin/unbound-rules
    wrapProgram $out/bin/unbound-rules --prefix PATH : ${lib.makeBinPath [bash curl]}
  '';
}
