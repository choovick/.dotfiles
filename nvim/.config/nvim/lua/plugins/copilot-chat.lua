return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
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
        "<leader>ze",
        ":CopilotChatToggle<CR>",
        mode = "n",
        desc = "Toggle Copilot Chat"
      },
      {
        "<leader>zr",
        ":CopilotChatExplain<CR>",
        mode = "v",
        desc = "Explain Code"
      },
      {
        "<leader>zf",
        ":CopilotChatReview<CR>",
        mode = "v",
        desc = "Review Code"
      },
      {
        "<leader>zo",
        ":CopilotChatFix<CR>",
        mode = "v",
        desc = "Fix Code Issues"
      },
      {
        "<leader>zd",
        ":CopilotChatOptimize<CR>",
        mode = "v",
        desc = "Optimize Code"
      },
      {
        "<leader>zt",
        ":CopilotChatDocs<CR>",
        mode = "v",
        desc = "Generate Docs"
      },
      {
        "<leader>zm",
        ":CopilotChatTests<CR>",
        mode = "v",
        desc = "Generate Tests"
      },
      {
        "<leader>zs",
        ":CopilotChatCommit<CR>",
        mode = "n",
        desc = "Generate Commit Message"
      },
    },
  },
}