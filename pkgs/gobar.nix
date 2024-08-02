{pkgs, ...}:
pkgs.buildGoModule {
  name = "gobar";

  src = pkgs.fetchFromGitHub {
    owner = "drsherluck";
    repo = "gobar";
    rev = "09b79b21ad7beca937830a688b6e6019b917a38e";
    hash = "sha256-rrwkQNTthPUrSR2eP3DAU8oRptBFLC0EIpQwMXXpW00=";
  };

  vendorHash = "sha256-qFdaH9A8m7oPKOvXWkIrseEbx8Ht8aFqB1lHA75X5fw=";
}
