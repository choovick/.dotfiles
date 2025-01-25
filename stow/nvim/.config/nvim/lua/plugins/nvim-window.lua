-- nvim-window plugin
--
-- Easily jump between windows in the current tab page
-- Link: https://github.com/yorickpeterse/nvim-window
return {
  "yorickpeterse/nvim-window",
  keys = {
    {
      "<leader>wj",
      "<cmd>lua require('nvim-window').pick()<cr>",
      desc = "nvim-window: Jump to window",
    },
    {
      "<C-m>",
      "<cmd>lua require('nvim-window').pick()<cr>",
      desc = "nvim-window: Jump to window",
    },
  },
  config = true,
  lazy = false,
}
