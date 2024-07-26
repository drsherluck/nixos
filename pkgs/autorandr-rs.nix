# https://discourse.nixos.org/t/proper-way-to-configure-monitors/12341/3
{
  rustPlatform,
  fetchFromGitHub,
  scdoc,
  installShellFiles,
}:
rustPlatform.buildRustPackage rec {
  name = "autorandr-rs";
  src = fetchFromGitHub {
    owner = "theotherjimmy";
    repo = name;
    rev = "408764f2b42f4fea28e03a04f9826a8fee699086";
    hash = "sha256-ulAxffFWCHzuM1/GzSloesoMYQ8Lzc/7yvLRmHeeubs=";
  };
  cargoHash = "sha256-9OPWhbyg/tmc9xg/3dj+OtxVxoQ3tRDuF1yXi1jBAuY=";
  nativeBuildInputs = [scdoc installShellFiles];
  preFixup = ''
    installManPage $releaseDir/build/${name}-*/out/${name}.1
    installManPage $releaseDir/build/${name}-*/out/${name}.5
  '';
}
