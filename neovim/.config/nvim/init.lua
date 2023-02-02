require('plugins')
require('keybindings')
require('lualine-config')
require('mason-config')
require('lsp')

-- Colorschemes
require('colorschemes.vscode')

-- Options
vim.g.mapleader = "," -- Leader Key
vim.opt.termguicolors = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.hidden = true
vim.wo.nu = true -- number lines
vim.wo.rnu = true -- relative line numbering
vim.o.incsearch = true -- incremental search
vim.wo.signcolumn = "yes"
vim.o.mouse = 'a'
vim.wo.cursorline = true
vim.opt.list = true
vim.opt.listchars = "tab: ,trail:*"
vim.opt.scrolloff = 7
vim.opt.sidescrolloff = 7
vim.opt.shiftwidth=2
vim.opt.completeopt="menu,menuone,noselect"
