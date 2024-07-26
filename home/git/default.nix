{pkgs, ...}: let
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
    hooks = {
      pre-push = ./pre-push;
    };
    extraConfig = {
      commit.gpgsign = true;
      gpg.format = "ssh";
      # contains "* <contents of .ssh/id_ed25519.pub>"
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
    package = pkgs.git;
  };
}
