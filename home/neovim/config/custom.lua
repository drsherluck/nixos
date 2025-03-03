-- remove trailing whitespaces before saving
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    pattern = { '*' },
    command = [[%s/\s\+$//e]],
})

-- set extension to filetypes
vim.filetype.add({
    extension = {
        tf = 'terraform',
        vert = 'glsl',
        frag = 'glsl',
        comp = 'glsl',
        rchit = 'glsl',
        rgen = 'glsl',
        rmiss = 'glsl',
        shader = 'glsl',
    }
})

-- set indent to two for some filetypes
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'nix', 'terraform', 'toml' },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
    end
})

local opts = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap

-- move around buffers
map('n', '<leader>n', '<cmd>bn<cr>', opts)
map('n', '<leader>p', '<cmd>bp<cr>', opts)
map('n', '<leader>d', '<cmd>bp|bd #<cr>', opts)

-- splits

-- bindings for launching telescope pickers
local ts = require('telescope.builtin')

local function make_cwd_opts()
    local dir = vim.fn.system("git rev-parse --show-toplevel")
    if vim.v.shell_error == 0 then return { cwd = string.sub(dir, 1, -2) } else return {} end
end

local function find_files()
    ts.find_files(make_cwd_opts())
end

local function live_grep()
    ts.live_grep(make_cwd_opts())
end

vim.keymap.set('n', '<leader>fd', ts.find_files, {})
vim.keymap.set('n', '<leader>ff', find_files, {})
vim.keymap.set('n', '<leader>fg', live_grep, {})
vim.keymap.set('n', '<leader>fb', ts.buffers, {})
vim.keymap.set('n', '<leader>fh', ts.help_tags, {})

--- go templated files
vim.filetype.add({
  extension = {
    gotmpl = 'gotmpl',
  },
  pattern = {
    [".*/templates/.*%.tpl"] = "helm",
    [".*/templates/.*%.ya?ml"] = "helm",
    ["helmfile.*%.ya?ml"] = "helm",
  },
})

-- enable folding
vim.api.nvim_create_autocmd('FileType', {
    callback = function()
        if require('nvim-treesitter.parsers').has_parser() then
            vim.o.foldmethod = 'expr'
            vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
        else
            vim.o.foldmethod = 'syntax'
        end
    end
})
