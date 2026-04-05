{pkgs, ...}: {
  programs.zsh = {
    enable = true;

    history = {
      size = 5000;
      path = "$HOME/.zsh_history";
      ignoreAllDups = true;
      extended = true;
    };

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      wtc() {
          if [ -z "$1" ]; then
              echo "Usage: wtc <branch-name>"
              return 1
          fi

          local branch_name=$1
          local target_dir="../$branch_name"

          git worktree add -b "$branch_name" "$target_dir"

          if [ $? -eq 0 ]; then
              cd "$target_dir"
          fi
      }
    '';

    shellAliases = {
      k = "kubectl";
      v = "nvim";
      vim = "nvim";
      cl = "clear";
      cpv = "rsync -ah --info=progress2";
      ls = "eza --color=auto";
      l = "eza --long --header --no-permissions --octal-permissions --group-directories-first --no-quotes -a";
      ll = "eza --long --header --no-permissions --octal-permissions --group-directories-first --no-quotes --ignore-glob='__pycache__'";
      lt = "eza --tree --level 2 --long --group-directories-first --no-permissions --no-time --no-user --no-quotes --ignore-glob='__pycache__'";
      cg = "cd `git rev-parse --show-toplevel`";
      tf = "terraform";
      tree = "eza --tree --group-directories-first";
      cat = "bat";
      ga = "git add";
      gl = "git pull";
      gp = "git push";
      gdf = "git difftool -y";
      gch = "git checkout";
      gsw = "git switch";
      gsd = "git switch \"$(git symbolic-ref refs/remotes/origin/HEAD | cut -f4 -d/)\" && gpru && gl";
      glo = "git log --oneline";
      gwa = "wtc";
      gwr = "git worktree remove";
      ff = "fastfetch";
      oc = "OPENROUTER_KEY=\"$(pass show llm/openrouter)\" GEMINI_KEY=\"$(pass show llm/gemini)\" AWS_PROFILE=\"none\" nix run github:nixos/nixpkgs/nixos-unstable#opencode";
    };

    plugins = [
      {
        name = "zsh-vi-mode";
        src = pkgs.fetchFromGitHub {
          owner = "jeffreytse";
          repo = "zsh-vi-mode";
          rev = "v0.11.0";
          hash = "sha256-xbchXJTFWeABTwq6h4KWLh+EvydDrDzcY9AQVK65RS8=";
        };
      }
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs.fzf;
  };
}
