return {
  { "mbbill/undotree", cmd = "UndotreeToggle" },

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
        "kotlin",
        "go",
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
    cmd = {
      "KittyScrollbackGenerateKittens",
      "KittyScrollbackCheckHealth",
      "KittyScrollbackGenerateCommandLineEditing",
    },
    event = { "User KittyScrollbackLaunch" },
    config = function()
      require("kitty-scrollback").setup()
    end,
  },
}
