vim.g.mapleader = ","


-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Gitsigns
vim.keymap.set('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<cr>', {})
vim.keymap.set('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<cr>', {})
vim.keymap.set('n', '<leader>hd', '<cmd>Gitsigns diffthis<cr>', {})

-- LSP
vim.keymap.set('n', '<leader>gd', function() vim.lsp.buf.definiton() end, {})
vim.keymap.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, {})
vim.keymap.set('n', '<leader>gr', function() vim.lsp.buf.references() end, {})
vim.keymap.set('n', '<leader>r', function() vim.lsp.buf.rename() end, {})

-- Luasnip
vim.keymap.set({ "i" }, "<C-K>", function() require('luasnip').expand() end, { silent = true })

-- UndoTree
vim.keymap.set('n', '<leader>U', vim.cmd.UndotreeToggle, {})

-- BufferLine
vim.keymap.set('n', 'H', '<cmd>BufferLineCyclePrev<cr>', {})
vim.keymap.set('n', 'L', '<cmd>BufferLineCycleNext<cr>', {})

-- Floaterm
vim.keymap.set('n', '<M-3>', '<cmd>FloatermToggle<cr>', {})

-- Netrw
vim.keymap.set('n', '<leader>e', '<cmd>Lexplore<cr>', {})
