return {
  -- {
  --   "supermaven-inc/supermaven-nvim",
  --   config = function()
  --     require("supermaven-nvim").setup({
  --       keymaps = {
  --         accept_suggestion = "<C-a>",
  --       },
  --     })
  --     require("supermaven-nvim.api").use_free_version()
  --   end,
  -- },
  {
    "mbbill/undotree",
    config = function()
      vim.cmd([[
                if has("persistent_undo")
                let target_path = expand('~/.undodir')

                    if !isdirectory(target_path)
                        call mkdir(target_path, "p", 0700)
                    endif

                    let &undodir=target_path
                    set undofile
                endif
            ]])
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        position = "right",
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        php = { { "pint", "php_cs_fixer" } },
      },
    },
  },

  {
    "adalessa/laravel.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "tpope/vim-dotenv",
      "MunifTanjim/nui.nvim",
      "nvimtools/none-ls.nvim",
    },
    cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
    event = { "VeryLazy" },
    config = true,
  },
  {
    -- Add the blade-nav.nvim plugin which provides Goto File capabilities
    -- for Blade files.
    "ricardoramirezr/blade-nav.nvim",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    ft = { "blade", "php" },
  },

  {
    "nvimdev/dashboard-nvim",
    opts = function(_, opts)
      local logo = [[


███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
                                                  
        ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "java",
        "html",
        "css",
        "typescript",
        "javascript",
        "lua",
        "luadoc",
        "jsdoc",
        "json",
        "python",
        "regex",
        "rust",
        "markdown",
        "markdown_inline",
        "toml",
        "yaml",
        "tsx",
        "vim",
        "vimdoc",
        "xml",
        "diff",
        "printf",
        "query",
        "luap",
        "jsonc",
        "kotlin",
      },
    },
  },
  {
    "pieces-app/plugin_neo_vim",
    config = function()
      require("pieces.config").host = "http://localhost:1000"
    end,
  },
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
}
