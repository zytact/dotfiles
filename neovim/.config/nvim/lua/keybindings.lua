vim.api.nvim_set_keymap('i', 'jj', '<Esc>', {noremap = true})

local bufopts = { noremap=true, silent=true, buffer=bufnr }
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

vim.cmd 'imap <expr> <C-j>   vsnip#expandable()  ? \'<Plug>(vsnip-expand-or-jump)\'         : \'<C-j>\''
vim.cmd 'smap <expr> <C-j>   vsnip#expandable()  ? \'<Plug>(vsnip-expand-or-jump)\'         : \'<C-j>\''

-- Paste from and Copy to from clipboard
vim.api.nvim_set_keymap('n', '<Leader>P', '"+p', {noremap = true})
vim.api.nvim_set_keymap('v', '<Leader>Y', '"+y', {noremap = true})

-- Change 2 split windows from vert to horiz or horiz to vert
vim.api.nvim_set_keymap('', '<Leader>th', '<C-w>t<C-w>H', {noremap = true})
vim.api.nvim_set_keymap('', '<Leader>tk', '<C-w>t<C-w>K', {noremap = true})

-- Map Window Switching to something easier
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {noremap = true})
