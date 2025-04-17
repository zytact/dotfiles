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
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      provider = "copilot",
      copilot = {
        model = "claude-3.7-sonnet",
        temperature = 0,
        max_completion_tokens = 8192,
      },
      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        if hub then
          return hub:get_active_servers_prompt()
        else
          return nil -- or return an empty string / table / appropriate fallback
        end
      end,
      -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
      custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
      end,
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
    },
    cmd = "MCPHub", -- lazy load by default
    build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
    config = function()
      require("mcphub").setup({
        extensions = {
          avante = {
            make_slash_command = true,
          },
        },
      })
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        auto_trigger = true,
      },
    },
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
    build = "cd rustowl && cargo install --path . -F installer --locked",
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
}
