{
  fetchFromGitHub,
  stdenv,
  xorg,
  pkg-config,
  gnumake,
}:
stdenv.mkDerivation {
  name = "fastcompmgr";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "tycho-kirchner";
    repo = "fastcompmgr";
    rev = "v0.2";
    hash = "sha256-NDzUGuNDXyjpZY5z7pKvSBmzgYhSnNTRAwQXIWaau7E=";
  };
  nativeBuildInputs = [
    pkg-config
    gnumake
  ];
  buildInputs = [
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXfixes
    xorg.libXrender
  ];

  buildPhase = "make";
  installPhase = ''
    mkdir -p $out/bin
    cp -t $out/bin fastcompmgr
    mkdir -p $out/share/man/man1
    cp -t $out/share/man/man1 fastcompmgr.1
  '';
}
