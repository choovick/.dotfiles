return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- Only the terminal module is enabled (required by leaf.nvim).
    -- The previous picker/zen config lives in git history (pre-41740e0).
    terminal = { enabled = true },
  },
}
