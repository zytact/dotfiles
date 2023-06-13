-- -- Additional Plugins <https://www.lunarvim.org/docs/configuration/plugins/user-plugins>
lvim.plugins = {
    { "catppuccin/nvim",         name = "catppuccin" },
    { "Mofiqul/vscode.nvim",     name = "vscode-dark" },
    { "navarasu/onedark.nvim" },
    { 'rose-pine/neovim',        name = 'rose-pine' },
    { "f-person/git-blame.nvim", name = 'git-blame' },
    { "mbbill/undotree",         name = 'undotree' },
    {
        'Saecki/crates.nvim',
        name = 'crates',
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            require('crates').setup()
        end
    },
    {
        'norcalli/nvim-colorizer.lua',
        name = 'nvim-colorizer',
        config = function()
            require('colorizer').setup()
        end
    },
    { "Shatur/neovim-ayu" },
}
