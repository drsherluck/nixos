require("catppuccin").setup {
    styles = {
        keywords = { "bold" },
        conditionals = { "bold" },
        loops = { "bold" },
    },
    integrations = {
	    treesitter = true
    },
    native_lsp = {
        enabled = true
    },
    transparent_background = true,
}

vim.cmd.colorscheme "catppuccin"
