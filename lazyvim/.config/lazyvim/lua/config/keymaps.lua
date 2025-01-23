-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local wk = require("which-key")
wk.add({
  { "<leader>a", group = "ai", icon = "  " },
})
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>", { noremap = true, silent = true })
