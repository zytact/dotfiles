return {
  -- {
  --   "catppuccin/nvim",
  --   config = function()
  --     require("catppuccin").setup({
  --       flavour = "mocha",
  --       transparent_background = false,
  --     })
  --   end,
  -- },

  -- {
  --   "craftzdog/solarized-osaka.nvim",
  --   config = function()
  --     require("solarized-osaka").setup({
  --       transparent = true,
  --     })
  --   end,
  -- },

  {
    "Shatur/neovim-ayu",
    config = function()
      require("ayu").setup({
        overrides = {
          Normal = { bg = "None" },
          ColorColumn = { bg = "None" },
          SignColumn = { bg = "None" },
          Folded = { bg = "None" },
          FoldColumn = { bg = "None" },
          CursorLine = { bg = "None" },
          CursorColumn = { bg = "None" },
          WhichKeyFloat = { bg = "None" },
          VertSplit = { bg = "None" },
        },
      })
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "ayu-dark",
    },
  },
}
