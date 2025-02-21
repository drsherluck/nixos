require('bigfile').setup {
  filesize = 2, -- in MiB
  pattern = { '*' },
  features = {
    'indent_blankline',
    'illuminate',
    'lsp',
    'treesitter',
    'syntax',
    'matchparen',
    'vimopts',
    'filetype',
  },
}
