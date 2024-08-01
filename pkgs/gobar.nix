{pkgs, ...}:
pkgs.buildGoModule {
  name = "gobar";

  src = pkgs.fetchFromGitHub {
    owner = "drsherluck";
    repo = "gobar";
    rev = "71faabf20d01a0a2dc2b4db4d05e975249c624e8";
    hash = "sha256-gilSstNuYqNhJlfYql1E3cFpYkL11+hsPFd8AzsuqM8=";
  };

  vendorHash = "sha256-MNKLU/pgugW75RyCpiL9uf3I5TL6DvUvq6vUUCmX6/s=";
}
