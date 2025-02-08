{pkgs, ...}: {
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config.global = {
      hide_env_diff = true;
    };
  };

  home.packages = with pkgs; [
    # core
    gnumake
    git
    gh
    cmake
    pkg-config

    # c/c++ tools
    valgrind
    gdb

    # languages
    gcc
    rustup
    go

    # vulkan
    glslang
    vulkan-loader
    vulkan-tools
    vulkan-validation-layers
    renderdoc
    gpu-viewer
  ];

  home.sessionVariables = {
    GOPATH = "$HOME/.local/share/go";
  };
}
