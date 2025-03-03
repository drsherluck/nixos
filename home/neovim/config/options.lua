-- general stuff
vim.o.backup = false
vim.o.termguicolors = true
vim.o.clipboard = "unnamedplus"
vim.o.signcolumn = "yes"
vim.o.number = true
vim.o.relativenumber = true
vim.o.ruler = true
vim.o.swapfile = false -- avoid annoyance
vim.o.updatetime = 250
vim.o.wrap = false
vim.o.showbreak = "↳  "
vim.o.scrolloff = 10
vim.o.foldenable = false
-- use ripgrep
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.grepprg = "rg --hidden --vimgrep --smart-case --"
-- indentation
local indent = 4
vim.o.tabstop = indent
vim.o.shiftwidth = indent
vim.o.softtabstop = indent
vim.o.expandtab = true
-- search
vim.o.incsearch = true
vim.o.hlsearch = true
-- undo
vim.o.undodir = os.getenv("HOME") .. "/.cache/nvim/undo/"
vim.o.undofile = true
-- turn off lsp logging
vim.lsp.set_log_level("off")
-- leader
local leader = ' '
vim.g.mapleader = leader
vim.g.maplocalleader = leader
