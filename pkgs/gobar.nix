{pkgs, ...}:
pkgs.buildGoModule {
  name = "gobar";

  src = pkgs.fetchFromGitHub {
    owner = "drsherluck";
    repo = "gobar";
    rev = "29a79b1a1dc761835157b963d113f5fbd95d22e9";
    hash = "sha256-lebQojpdz0eswONC/9AIf2Z7ewg5bQZfwnTsONQtyvU=";
  };

  vendorHash = "sha256-qFdaH9A8m7oPKOvXWkIrseEbx8Ht8aFqB1lHA75X5fw=";
}
