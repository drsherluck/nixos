{pkgs, ...}:
pkgs.buildGoModule {
  name = "gobar";

  src = pkgs.fetchFromGitHub {
    owner = "drsherluck";
    repo = "gobar";
    rev = "413c1138a7668e58d18b9983d28399867dbc80c0";
    hash = "sha256-kCUHUfyvtYrlsipvyfkt+PxpLKK21vSGyL+ZO2BxXzk=";
  };

  vendorHash = "sha256-qFdaH9A8m7oPKOvXWkIrseEbx8Ht8aFqB1lHA75X5fw=";
}
