vim.g.mapleader = ","


vim.api.nvim_set_keymap('n', 'gd', '<Cmd>call VSCodeNotify("editor.action.revealDefinition")<CR>', { noremap = true })

vim.api.nvim_set_keymap('n', '<leader>r', '<Cmd>call VSCodeNotify("editor.action.rename")<CR>', { noremap = true })

vim.api.nvim_set_keymap('n', '<leader>e', '<Cmd>call VSCodeNotify("workbench.view.explorer")<CR>', { noremap = true })
