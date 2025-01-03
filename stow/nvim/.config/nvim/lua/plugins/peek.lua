return {
  "toppair/peek.nvim",
  event = { "VeryLazy" },
  enabled = true,
  build = "deno task --quiet build:fast",
  config = function()
    require("peek").setup()
    vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
    vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
  end,
  keys = {
    { "<leader>cg", "<cmd>PeekOpen<cr>", desc = "Peek preview" },
  },
}
