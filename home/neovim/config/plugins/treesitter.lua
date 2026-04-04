require('nvim-treesitter').setup {
    ensure_installed = { },
    sync_install = false,
    auto_install = false,
    ignore_install = { },
    highlight = {
        enable = true,
        disable = { 'help' },
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true
    },
}

vim.api.nvim_create_autocmd('FileType', {
    pattern = {
      'bash',
      'c',
      'cmake',
      'cpp',
      'dockerfile',
      'glsl',
      'go',
      'gotmpl',
      'hcl',
      'hlsl',
      'jq',
      'json',
      'just',
      'lua',
      'make',
      'markdown',
      'nix',
      'python',
      'rust',
      'slang',
      'toml',
      'vim',
      'yaml',
      'zig',
    },
    callback = function()
        vim.treesitter.start()
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo.foldmethod = 'expr'
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
