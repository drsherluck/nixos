{pkgs, ...}:
pkgs.buildGoModule {
  name = "gobar";

  src = pkgs.fetchFromGitHub {
    owner = "drsherluck";
    repo = "gobar";
    rev = "81f2b5cce3a89f2fc9069e4f3b5f75db79ad25da";
    hash = "sha256-I44PGm9dNmeQpNf6d/W9eSmniUm5T60QjmA9EByP5VE=";
  };

  vendorHash = "sha256-MNKLU/pgugW75RyCpiL9uf3I5TL6DvUvq6vUUCmX6/s=";
}
