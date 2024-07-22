return {
  -- {
  --   "catppuccin/nvim",
  --   config = function()
  --     require("catppuccin").setup({
  --       flavour = "mocha",
  --       transparent_background = true,
  --     })
  --   end,
  -- },

  {
    "craftzdog/solarized-osaka.nvim",
    config = function()
      require("solarized-osaka").setup({
        transparent = true,
      })
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "solarized-osaka",
    },
  },
}
