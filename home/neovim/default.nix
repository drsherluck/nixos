{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = false;
    withRuby = false;

    extraPackages = with pkgs; [
      lua-language-server
      rust-analyzer
      clang-tools
      zls
      ruff
      python313Packages.python-lsp-server
      python313Packages.python-lsp-ruff
      nil
      gopls
      terraform-ls
      tree-sitter
      tinymist
      fd
    ];

    plugins = with pkgs.vimPlugins; [
      {
        plugin = neoscroll-nvim;
        type = "lua";
        config = ''
          require('neoscroll').setup()
        '';
      }
      {
        plugin = plenary-nvim;
      }
      {
        plugin = bigfile-nvim;
        type = "lua";
        config = builtins.readFile ./config/plugins/bigfile.lua;
      }
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = ''
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
        type = "lua";
        config = builtins.readFile ./config/plugins/lsp.lua;
      }
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile ./config/plugins/cmp.lua;
      }
      cmp_luasnip
      cmp-nvim-lsp
      luasnip
      friendly-snippets
      # visual: gc
      # normal: [count]gcc
      {
        plugin = comment-nvim;
        type = "lua";
        config = ''
          require('Comment').setup()
        '';
      }
      {
        plugin = catppuccin-nvim;
        type = "lua";
        config = builtins.readFile ./config/plugins/color.lua;
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require('lualine').setup {
            options = { theme = "catppuccin-nvim" }
          }
        '';
      }
      nvim-web-devicons
      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile ./config/plugins/telescope.lua;
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
          p.tree-sitter-jinja
        ]);
        type = "lua";
        config = builtins.readFile ./config/plugins/treesitter.lua;
      }
      nvim-treesitter-parsers.vimdoc
      {
        plugin = oil-nvim;
        type = "lua";
        config = builtins.readFile ./config/plugins/oil.lua;
      }
    ];

    initLua = ''
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
