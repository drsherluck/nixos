{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    google-cloud-sdk
    aws-vault
    kubectl
    tenv
    pass
    fluxcd
  ];

  programs.awscli = {
    enable = true;
    package = pkgs.awscli2;
  };

  programs.gpg.enable = lib.mkForce true;

  services.gpg-agent = {
    enable = lib.mkForce true;
    pinentryPackage = lib.mkDefault pkgs.pinentry-curses;
  };

  home.sessionVariables = {
    GOOGLE_APPLICATION_CREDENTIALS = "$HOME/.config/gcloud/application_default_credentials.json";
    AWS_VAULT_BACKEND = "pass";
  };
}
