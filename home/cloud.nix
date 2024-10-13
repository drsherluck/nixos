{
  pkgs,
  lib,
  ...
}: let
  eks-token-cache = pkgs.writeShellScriptBin "eks-token-cache" ''
    now=''$(date +%s)
    tokenfile="$(dirname "''${KUBECONFIG:-"''$HOME/.kube/config"}")/.''$2.token"

    if [ -f ''$tokenfile ]; then
      expertime=''$(jq '.status.experationTimestamp' ''$tokenfile | xargs -rn1 date +%s -d)
      if [[ ''$((now-30)) -gt ''$expertime ]]; then
        gentoken="true"
      fi
    else
      gentoken="true"
    fi

    if [[ ''$gentoken == "true" ]]; then
      aws-vault exec ''$3 -- \
        aws eks get-token \
        --region ''$1 \
        --cluster-name ''$2 \
        --output json > ''$tokenfile
    fi

    cat ''$tokenfile
  '';

  eks-configure-kube = pkgs.writeShellScriptBin "eks-configure-kube" ''
    CLUSTER_NAME="''$1"
    AWS_REGION="''$2"
    AWS_PROFILE="''$3"

    aws-vault exec "''$AWS_PROFILE" -- \
      aws eks update-kubeconfig \
      --name "''$CLUSTER_NAME" \
      --region "''$AWS_REGION"

    yq -i ".users |= map(with(select(.name == \"*/''$CLUSTER_NAME\");
            .user.exec.command = \"eks-token-cache\" |
            .user.exec.args = [\"''$AWS_REGION\", \"''$CLUSTER_NAME\", \"''$AWS_PROFILE\"]
        ))" "''${KUBECONFIG:-"''$HOME/.kube/config"}"
  '';
in {
  home.packages = with pkgs; [
    google-cloud-sdk
    aws-vault
    kubectl
    tenv
    pass
    fluxcd
    eks-token-cache
    eks-configure-kube
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
    TF_PLUGIN_CACHE_DIR = "$HOME/.terraform.d/plugin-cache";
  };
}
