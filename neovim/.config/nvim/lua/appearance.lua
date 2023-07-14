--require('catppuccin').setup({
--	transparent_background = true
--})

--vim.cmd.colorscheme 'catppuccin'

--require('github-theme').setup({
--    options = {
--        transparent = true,
--    }
--})

--vim.cmd('colorscheme github_dark_dimmed')

require('rose-pine').setup({
    disable_background = true
})

vim.cmd('colorscheme rose-pine')

require('lualine').setup()
