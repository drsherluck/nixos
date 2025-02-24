{pkgs, ...}: let
  toLua = str: "lua << EOF\n${str}\nEOF\n";
  toLuaFile = file: toLua (builtins.readFile file);
in {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      lua-language-server
      rust-analyzer
      clang-tools
      zls
      ruff
      python312Packages.python-lsp-server
      python312Packages.python-lsp-ruff
      nil
      gopls
      terraform-ls
      tinymist
    ];

    plugins = with pkgs.vimPlugins; [
      {
        plugin = neoscroll-nvim;
        config = toLua ''
          require('neoscroll').setup()
        '';
      }
      {
        plugin = bigfile-nvim;
        config = toLuaFile ./config/plugins/bigfile.lua;
      }
      {
        plugin = indent-blankline-nvim;
        config = toLua ''
          require('ibl').setup {
            scope = {
              show_start = false,
              show_end = false,
            }
          }
        '';
      }
      {
        plugin = nvim-lspconfig;
        config = toLuaFile ./config/plugins/lsp.lua;
      }
      {
        plugin = nvim-cmp;
        config = toLuaFile ./config/plugins/cmp.lua;
      }
      cmp_luasnip
      cmp-nvim-lsp
      luasnip
      friendly-snippets
      # visual: gc
      # normal: [count]gcc
      {
        plugin = comment-nvim;
        config = toLua ''
          require('Comment').setup()
        '';
      }
      {
        plugin = catppuccin-nvim;
        config = toLuaFile ./config/plugins/color.lua;
      }
      {
        plugin = lualine-nvim;
        config = toLua ''
          require('lualine').setup {
            options = { theme = "catppuccin" }
          }
        '';
      }
      nvim-web-devicons
      {
        plugin = telescope-nvim;
        config = toLuaFile ./config/plugins/telescope.lua;
      }
      telescope-fzf-native-nvim
      {
        plugin = nvim-treesitter.withPlugins (p: [
          p.tree-sitter-lua
          p.tree-sitter-glsl
          p.tree-sitter-hlsl
          p.tree-sitter-slang
          p.tree-sitter-nix
          p.tree-sitter-bash
          p.tree-sitter-jq
          p.tree-sitter-python
          p.tree-sitter-go
          p.tree-sitter-gotmpl
          p.tree-sitter-zig
          p.tree-sitter-hcl
          p.tree-sitter-cpp
          p.tree-sitter-c
          p.tree-sitter-rust
          p.tree-sitter-make
          p.tree-sitter-yaml
          p.tree-sitter-helm
          p.tree-sitter-toml
          p.tree-sitter-json
          p.tree-sitter-markdown
          # p.tree-sitter-typst
          p.tree-sitter-cmake
          p.tree-sitter-dockerfile
          p.tree-sitter-vim
          p.tree-sitter-just
        ]);
        config = toLuaFile ./config/plugins/treesitter.lua;
      }
      nvim-treesitter-parsers.vimdoc
      {
        plugin = oil-nvim;
        config = toLuaFile ./config/plugins/oil.lua;
      }
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./config/options.lua}
      ${builtins.readFile ./config/custom.lua}
    '';
  };

  # inject-go-tmpl function configured in config/custom.lua
  xdg.configFile."nvim/queries/gotmpl/injections.scm".text = ''
    ((text) @injection.content
     (#set! injection.language "html")
     (#set! injection.combined))
  '';
}
