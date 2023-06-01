lvim.format_on_save = {
  enabled = true,
  pattern = { "*.lua", "*.rs", "*.py" },
  timeout = 1000,
}

-- -- linters, formatters and code actions <https://www.lunarvim.org/docs/configuration/language-features/linting-and-formatting>
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    command = "rustfmt",
    filetypes = { "rust" }
  },
  {
    name = "autopep8",
    filetypes = { "python" }
  }
  -- { command = "stylua" },
  --   {
  --     command = "prettier",
  --     extra_args = { "--print-width", "100" },
  --     filetypes = { "typescript", "typescriptreact" },
  --   },
}
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  -- { command = "flake8", filetypes = { "python" } },
  {
    command = "shellcheck",
    args = { "--severity", "warning" },
    filetypes = { "sh" }
  },
}
-- local code_actions = require "lvim.lsp.null-ls.code_actions"
-- code_actions.setup {
--   {
--     exe = "eslint",
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }
