return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = false,
    branch = "main",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    -- https://github.com/jellydn/lazy-nvim-ide/blob/main/lua/plugins/extras/copilot-chat-v2.lua
    -- https://github.com/CopilotC-Nvim/CopilotChat.nvim?tab=readme-ov-file#default-configuration
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    keys = {
      {
        "<leader>zz",
        ":CopilotChatToggle<CR>",
        mode = "n",
        desc = "Toggle Copilot Chat"
      },
      {
        "<leader>ze",
        ":CopilotChatExplain<CR>",
        mode = "v",
        desc = "Explain Code"
      },
      {
        "<leader>zr",
        ":CopilotChatReview<CR>",
        mode = "v",
        desc = "Review Code"
      },
      {
        "<leader>zf",
        ":CopilotChatFix<CR>",
        mode = "v",
        desc = "Fix Code Issues"
      },
      {
        "<leader>zo",
        ":CopilotChatOptimize<CR>",
        mode = "v",
        desc = "Optimize Code"
      },
      {
        "<leader>zd",
        ":CopilotChatDocs<CR>",
        mode = "v",
        desc = "Generate Docs"
      },
      {
        "<leader>zt",
        ":CopilotChatTests<CR>",
        mode = "v",
        desc = "Generate Tests"
      },
      {
        "<leader>zc",
        ":CopilotChatCommit<CR>",
        mode = "n",
        desc = "Generate Commit Message"
      },
    },
  },
}
