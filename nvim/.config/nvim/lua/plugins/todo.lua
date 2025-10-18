return {
  "folke/todo-comments.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "]t",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next todo comment",
    },
    {
      "[t",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Previous todo comment",
    },
    {
      "<leader>ft",
      function()
        vim.cmd("TodoTelescope")
      end,
      desc = "Find TODOs Telescope",
    },
    {
      "<leader>fT",
      function()
        vim.cmd("TodoFzf")
      end,

      desc = "Find todos Fzf",
    },
  },
  config = function()
    require("todo-comments").setup()
  end,
}
