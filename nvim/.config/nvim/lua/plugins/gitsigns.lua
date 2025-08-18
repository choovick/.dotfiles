-- https://github.com/lewis6991/gitsigns.nvim?tab=readme-ov-file#installation--usage
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {},
  keys = {
    { "<leader>cp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview hunk" },
    { "<leader>cP", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset hunk" },
    { "<leader>cb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle current line blame" },
    { "<leader>cy", "<cmd>Gitsigns blame_line<cr>", desc = "Show full blame for current line" },
    { "<leader>cY", function()
      local line = vim.api.nvim_win_get_cursor(0)[1]
      local file = vim.api.nvim_buf_get_name(0)
      local cmd = string.format("git blame -L %d,%d --porcelain %s | head -1 | cut -d' ' -f1", line, line, vim.fn.shellescape(file))
      local commit = vim.fn.system(cmd):gsub("%s+", "")

      if commit and commit ~= "" and not commit:match("^fatal:") then
        vim.fn.setreg("+", commit)
        vim.fn.setreg("*", commit) -- Also set * register for extra compatibility
        vim.notify("Yanked commit: " .. commit)
      else
        vim.notify("No commit info available for this line")
      end
    end, desc = "Yank current line commit hash" },
    { "<leader>cn", "<cmd>Gitsigns next_hunk<cr>", desc = "Next hunk" },
    { "<leader>cN", "<cmd>Gitsigns prev_hunk<cr>", desc = "Previous hunk" },
  },
}
