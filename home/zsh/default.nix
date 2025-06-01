{pkgs, ...}: {
  programs.zsh = {
    enable = true;

    history = {
      size = 5000;
      path = "$HOME/.zsh_history";
      ignoreAllDups = true;
    };

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      k = "kubectl";
      v = "nvim";
      vim = "nvim";
      cl = "clear";
      cpv = "rsync -ah --info=progress2";
      ls = "eza --color=auto";
      l = "eza --long --header --no-permissions --octal-permissions --group-directories-first --no-quotes -a";
      ll = "eza --long --header --no-permissions --octal-permissions --group-directories-first --no-quotes";
      lt = "eza --tree --level 2 --long --group-directories-first --no-permissions --no-time --no-user --no-quotes";
      cg = "cd `git rev-parse --show-toplevel`";
      tf = "terraform";
      tree = "eza --tree --group-directories-first";
      cat = "bat";
      #make = "make -j8";
      ga = "git add";
      gl = "git pull";
      gp = "git push";
      gdf = "git diff";
      gch = "git checkout";
      gsw = "git switch";
      gsd = "git switch \"$(git symbolic-ref refs/remotes/origin/HEAD | cut -f4 -d/)\" && gpru && gl";
      glo = "git log --oneline";
      ff = "fastfetch";
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
