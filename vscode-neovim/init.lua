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
	"<leader>c",
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
