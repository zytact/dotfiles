-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.clipboard = ""

-- Set tab width to 4 spaces
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.cursorline = false
vim.o.exrc = true
vim.o.termguicolors = true
vim.opt.fillchars = { eob = "~" }
vim.o.background = "light"
vim.g.t3_clawd_light_transparent = true
vim.o.wrap = true
vim.o.undodir = vim.fn.expand("~/.undodir")

if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font:h11"
  vim.g.neovide_opacity = 0.8
  vim.g.neovide_normal_opacity = 0.8
end
