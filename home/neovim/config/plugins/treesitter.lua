require('nvim-treesitter.configs').setup {
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
