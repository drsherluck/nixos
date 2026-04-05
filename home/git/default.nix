{
  pkgs,
  lib,
  ...
}: let
  # note: git branch -vva --format "%(refname) %(upstream)" | rg "refs/heads/([^ ]+) refs/remotes/.*$" -r "$1"
  git-prune = pkgs.writeShellScriptBin "gpru" ''
    #!/usr/bin/env bash
    workpath="''$(pwd)"
    if git rev-parse --git-dir > /dev/null 2>&1; then
      git fetch --prune --all -q; git-gone list | rg -v "''$(git rev-parse --abbrev-ref HEAD)" | xargs -rn1 git branch -D
      exit 0
    fi
    find "''$workpath" -maxdepth 1 -type d -print0 | parallel --will-cite -0 '
      echo {} && cd {} && if git rev-parse --git-dir > /dev/null 2>&1; then
        git fetch --prune --all -q; git-gone list | rg -v "''$(git rev-parse --abbrev-ref HEAD)" | xargs -rn1 git branch -D
      fi
    '
  '';
in {
  home.packages = with pkgs; [
    parallel
    git-gone
    git-prune
    git-filter-repo
  ];

  programs.delta = {
    enable = true;
    options = {
      navigate = true;
      light = false;
      side-by-side = false;
    };
    enableGitIntegration = true;
  };

  difftastic = {
    git.diffToolMode = true;
    display = "inline";
  };

  programs.git = {
    enable = true;

    hooks = {
      pre-push = ./pre-push;
    };

    signing.format = "openpgp";

    settings = {
      gpg.format = "ssh";
      commit.gpgsign = true;
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user = {
        signingkey = "~/.ssh/id_ed25519.pub";
        name = lib.mkDefault "drsherluck";
      };
      core = {
        editor = "nvim";
        whitespace = "error";
        preloadindex = true;
        compression = 9;
      };
    };
  };


  programs.gh = {
    enable = true;
    extensions = [pkgs.gh-eco];
    settings.git_protocol = "ssh";
  };

  programs.gh-dash = {
    enable = true;
  };
}
