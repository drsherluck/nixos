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
  useFetchCargoVendor = true;
  cargoHash = "sha256-9JSNEHXRv4lZ7ek9OC7rI8kKFc7VnweNpIU6xC+j6yE=";
  nativeBuildInputs = [scdoc installShellFiles];
  preFixup = ''
    installManPage $releaseDir/build/${name}-*/out/${name}.1
    installManPage $releaseDir/build/${name}-*/out/${name}.5
  '';
}
