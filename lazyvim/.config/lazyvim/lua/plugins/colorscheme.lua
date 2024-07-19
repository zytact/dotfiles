return {
  {
    "marko-cerovac/material.nvim",
    config = function()
      vim.g.material_style = "deep ocean"
      require("material").setup({
        disable = {
          background = true,
        },
      })
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "material",
    },
  },
}
