return {
  {
    "catppuccin/nvim",
    config = function()
      require("catppuccin").setup({
        flavour = "latte",
        transparent_background = false,
      })
    end,
  },

  {
    "craftzdog/solarized-osaka.nvim",
    config = function()
      require("solarized-osaka").setup({
        transparent = true,
      })
    end,
  },

  {
    "Shatur/neovim-ayu",
    --   config = function()
    --     require("ayu").setup({
    --       overrides = {
    --         Normal = { bg = "None" },
    --         ColorColumn = { bg = "None" },
    --         SignColumn = { bg = "None" },
    --         Folded = { bg = "None" },
    --         FoldColumn = { bg = "None" },
    --         CursorLine = { bg = "None" },
    --         CursorColumn = { bg = "None" },
    --         WhichKeyFloat = { bg = "None" },
    --         VertSplit = { bg = "None" },
    --       },
    --     })
    --   end,
  },

  {
    "EdenEast/nightfox.nvim",
    config = function()
      require("nightfox").setup({
        options = {
          transparent = false,
          styles = {
            comments = "italic",
            keywords = "bold",
            types = "italic,bold",
          },
        },
      })
    end,
  },

  {
    "olivercederborg/poimandres.nvim",
    config = function()
      require("poimandres").setup({
        disable_background = false,
      })
    end,
  },

  {
    "Mofiqul/vscode.nvim",
    config = function()
      local c = require("vscode.colors").get_colors()
      require("vscode").setup({
        transparent = true,
      })
    end,
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        styles = {
          transparency = true,
        },
      })
    end,
  },

  {
    "datsfilipe/vesper.nvim",
    config = function()
      require("vesper").setup({
        transparent = false,
        italics = {
          comments = true,
          keywords = true,
          functions = false,
          variables = false,
          strings = false,
        },
      })
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = ...,
    config = function()
      require("gruvbox").setup({
        transparent_mode = false,
      })
    end,
  },
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
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup({
        transparent = true,
      })
    end,
  },
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
  },

  {
    "nyoom-engineering/oxocarbon.nvim",
  },
  {
    "2nthony/vitesse.nvim",
    dependencies = {
      "tjdevries/colorbuddy.nvim",
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
    },
  },
  {
    "zenbones-theme/zenbones.nvim",
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = "rktjmp/lush.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        transparent = false,
        -- end,
      })
      vim.g.zenwritten_transparent_background = false
      vim.g.tokyobones_transparent_background = false
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
