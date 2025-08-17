-- https://github.com/lewis6991/gitsigns.nvim?tab=readme-ov-file#installation--usage
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {},
  keys = {
    { "<leader>cp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview hunk" },
    { "<leader>cP", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset hunk" },
    { "<leader>cb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle current line blame" },
    { "<leader>cn", "<cmd>Gitsigns next_hunk<cr>", desc = "Next hunk" },
    { "<leader>cN", "<cmd>Gitsigns prev_hunk<cr>", desc = "Previous hunk" },
  },
}
