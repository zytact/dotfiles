-- -- Additional Plugins <https://www.lunarvim.org/docs/configuration/plugins/user-plugins>
lvim.plugins = {
  { "catppuccin/nvim",     name = "catppuccin" },
  { "Mofiqul/vscode.nvim", name = "vscode-dark" },
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000 -- Ensure it loads first
  },
  { 'rose-pine/neovim',        name = 'rose-pine' },
  { "f-person/git-blame.nvim", name = 'git-blame' },
  { "mbbill/undotree",         name = "undotree" },
}
