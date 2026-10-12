return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "vtsls",
        "clangd",
        "emmet-language-server",
        "html-lsp",
        "json-lsp",
        "css-lsp",
        "prettier",
        "tailwindcss-language-server",
        "rust-analyzer",
        "shfmt",
        "sqlfluff",
        "stylua",
        "markdown-toc",
        "markdownlint-cli2",
        "prisma-language-server",
        "basedpyright",
        "ruff",
        "zls",
        "taplo",
        "nomicfoundation-solidity-language-server",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        vtsls = {
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = { enabled = "all" },
              },
            },
          },
        },
      },
    },
  },
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
