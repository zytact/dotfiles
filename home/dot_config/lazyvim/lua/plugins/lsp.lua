-- Syntax highlighting only: no LSP, Mason, completion, formatting or linting.
return {
  { "neovim/nvim-lspconfig", enabled = false },
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  { "stevearc/conform.nvim", enabled = false },
  { "mfussenegger/nvim-lint", enabled = false },
  { "saghen/blink.cmp", enabled = false },
  { "rafamadriz/friendly-snippets", enabled = false },
  { "folke/lazydev.nvim", enabled = false },
}
