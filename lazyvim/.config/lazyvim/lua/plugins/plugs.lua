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
    -- Add the blade-nav.nvim plugin which provides Goto File capabilities
    -- for Blade files.
    "ricardoramirezr/blade-nav.nvim",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    ft = { "blade", "php" },
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
    "pieces-app/plugin_neovim",
    lazy = false,
    priority = 1000,
    config = function()
      require("pieces.config").host = "http://localhost:1000"
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      model = "claude-3.5-sonnet",
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
}
