return {
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        compat = {},
        default = { "lsp", "path", "snippets", "buffer" },
        cmdline = {},
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "vtsls",
        "clangd",
        "emmet-language-server",
        "html-lsp",
        "json-lsp",
        "eslint_d",
        "css-lsp",
        "prettier",
        "tailwindcss-language-server",
        "pyright",
        "black",
        "ruff",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
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
