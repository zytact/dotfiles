-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

if vim.g.vscode then
  vim.g.mapleader = " "

  vim.api.nvim_set_keymap(
    "n",
    "gd",
    '<Cmd>lua require("vscode").call("editor.action.revealDefinition")<CR>',
    { noremap = true }
  )

  vim.api.nvim_set_keymap(
    "n",
    "<leader>r",
    '<Cmd>lua require("vscode").call("editor.action.rename")<CR>',
    { noremap = true }
  )

  vim.api.nvim_set_keymap(
    "n",
    "<leader>e",
    '<Cmd>lua require("vscode").call("workbench.view.explorer")<CR>',
    { noremap = true }
  )

  vim.api.nvim_set_keymap(
    "n",
    "<leader>ce",
    '<Cmd>lua require("vscode").call("inlineChat.start")<CR>',
    { noremap = true }
  )

  vim.api.nvim_set_keymap(
    "n",
    "<leader>ce",
    '<Cmd>lua require("vscode").call("inlineChat.start")<CR>',
    { noremap = true }
  )

  vim.api.nvim_set_keymap(
    "n",
    "<leader>cs",
    '<Cmd>lua require("vscode").call("workbench.panel.chat.view.copilot.focus")<CR>',
    { noremap = true }
  )

  vim.api.nvim_set_keymap(
    "n",
    "gt",
    '<Cmd>lua require("vscode").call("workbench.action.showAllSymbols")<CR>',
    { noremap = true }
  )

  vim.api.nvim_set_keymap(
    "n",
    "gs",
    '<Cmd>lua require("vscode").call("workbench.action.gotoSymbol")<CR>',
    { noremap = true }
  )

  vim.api.nvim_set_keymap(
    "n",
    "gr",
    '<Cmd>lua require("vscode").call("editor.action.goToReferences")<CR>',
    { noremap = true }
  )

  vim.api.nvim_set_keymap(
    "v",
    "<leader>ca",
    '<Cmd>lua require("vscode").call("inlineChat.start")<CR>',
    { noremap = true }
  )

  vim.api.nvim_set_keymap(
    "n",
    "<leader>aa",
    '<Cmd>lua require("vscode").call("workbench.panel.chat")<CR>',
    { noremap = true }
  )

  vim.api.nvim_set_keymap(
    "n",
    "<leader>h",
    '<Cmd>lua require("vscode").call("bookmarks.listFromAllFiles")<CR>',
    { noremap = true }
  )

  vim.api.nvim_set_keymap(
    "n",
    "<leader>H",
    '<Cmd>lua require("vscode").call("bookmarks.toggle")<CR>',
    { noremap = true }
  )
end
