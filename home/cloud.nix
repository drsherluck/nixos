{pkgs, ...}: {
  home.packages = with pkgs; [
    google-cloud-sdk
    kubectl
    tenv
  ];

  home.sessionVariables = {
    GOOGLE_APPLICATION_CREDENTIALS = "$HOME/.config/gcloud/application_default_credentials.json";
  };
}
