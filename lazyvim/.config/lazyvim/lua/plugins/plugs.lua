return {
  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<C-y>",
        },
      })
      require("supermaven-nvim.api").use_free_version()
    end,
  },
}
