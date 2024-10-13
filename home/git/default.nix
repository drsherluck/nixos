{
  pkgs,
  lib,
  ...
}: let
  # note: git branch -vva --format "%(refname) %(upstream)" | rg "refs/heads/([^ ]+) refs/remotes/.*$" -r "$1"
  git-prune = pkgs.writeShellScriptBin "git-prune" ''
    #!/usr/bin/env bash
    workpath="''$(realpath "''${1:-'.'}")"
    find "''$workpath" -maxdepth 1 -type d -print0 | parallel --will-cite -0 '
      echo {} && cd {} && [[ -d ".git" ]] &&
      (git-gone list | rg -v "''$(git rev-parse --abbrev-ref HEAD)" | xargs -rn1 git branch -D)
    '
  '';
in {
  home.packages = with pkgs; [
    parallel
    git-gone
    git-prune
  ];

  programs.git = {
    enable = true;
    userName = lib.mkDefault "drsherluck";

    hooks = {
      pre-push = ./pre-push;
    };

    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = false;
      };
    };

    extraConfig = {
      gpg.format = "ssh";
      commit.gpgsign = true;
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingkey = "~/.ssh/id_ed25519.pub";
      core.editor = "nvim";
    };
  };
}
