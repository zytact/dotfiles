vim.g.mapleader = ","


vim.api.nvim_set_keymap('n', 'gd', '<Cmd>call VSCodeNotify("editor.action.revealDefinition")<CR>', { noremap = true })

vim.api.nvim_set_keymap('n', '<leader>r', '<Cmd>call VSCodeNotify("editor.action.rename")<CR>', { noremap = true })
