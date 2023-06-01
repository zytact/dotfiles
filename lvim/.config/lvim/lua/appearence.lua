-- -- Change theme settings
lvim.colorscheme = "onedark"
-- lvim.transparent_window = false
lvim.builtin.lualine.style = "lvim"

-- Change other appearence settings
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- Onedark
require('onedark').setup {
  style = 'deep',
  transparent = true,
  code_style = {
    comments = 'italic',
    keywords = 'bold',
    functions = 'bold',
    strings = 'italic',
    variables = 'none'
  }
}
