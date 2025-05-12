-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.clipboard = ""

-- Set tab width to 4 spaces
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.cursorline = false
vim.g.autoformat = true
vim.o.exrc = true
vim.o.termguicolors = true
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"
vim.opt.fillchars = { eob = "~" }
vim.o.background = "light"

if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font:h12"
end
