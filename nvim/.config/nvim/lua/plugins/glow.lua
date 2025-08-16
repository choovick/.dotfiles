return {
  "ellisonleao/glow.nvim",
  config = true,
  cmd = "Glow",
  opts = {
    width = 300,
    height = 300,
    width_ratio = 0.9, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
    height_ratio = 0.9,
  },
  keys = {
    { "<leader>cG", "<cmd>Glow<cr>", desc = "Glow preview" },
  },
}
