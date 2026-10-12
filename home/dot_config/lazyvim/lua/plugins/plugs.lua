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
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
                        

███████╗██╗   ██╗████████╗ █████╗  ██████╗████████╗
╚══███╔╝╚██╗ ██╔╝╚══██╔══╝██╔══██╗██╔════╝╚══██╔══╝
  ███╔╝  ╚████╔╝    ██║   ███████║██║        ██║   
 ███╔╝    ╚██╔╝     ██║   ██╔══██║██║        ██║   
███████╗   ██║      ██║   ██║  ██║╚██████╗   ██║   
╚══════╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝ ╚═════╝   ╚═╝   
                        ]],
        },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
    },
    opts = {
      adapters = {
        ["neotest-vitest"] = {},
      },
    },
  },
  {
    "cordx56/rustowl",
    version = "*", -- Latest stable version
    build = "cd rustowl && cargo install --path . --locked",
    lazy = false, -- This plugin is already lazy
    opts = {},
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "Kaiser-Yang/blink-cmp-avante",
    },
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "avante" },
        providers = {
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
          },
        },
      },
    },
  },
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
    dependencies = {
      "nvim-telescope/telescope.nvim",
      -- "ibhagwan/fzf-lua",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      ---@type lc.lang
      lang = "python3",
    },
  },
  {
    "voltycodes/areyoulockedin.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
    config = function()
      require("areyoulockedin").setup({
        session_key = os.getenv("AREYOULOCKED"),
      })
    end,
  },
  {
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    lazy = true,
    cmd = {
      "KittyScrollbackGenerateKittens",
      "KittyScrollbackCheckHealth",
      "KittyScrollbackGenerateCommandLineEditing",
    },
    event = { "User KittyScrollbackLaunch" },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^6.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      require("kitty-scrollback").setup()
    end,
  },
  -- {
  --   "developedbyed/marko.nvim",
  --   config = function()
  --     require("marko").setup({
  --       width = 100,
  --       height = 100,
  --       border = "rounded",
  --       title = " Marks ",
  --     })
  --   end,
  -- },
}
