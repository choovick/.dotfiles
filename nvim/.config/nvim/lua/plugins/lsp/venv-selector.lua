return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-telescope/telescope.nvim",
    "mfussenegger/nvim-dap-python", -- optional for debugger support
  },

  event = 'VeryLazy', -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
  opts = {
    -- Your options go here
    -- name = "venv",
    -- auto_refresh = false
  },
  keys = {
    { "cv", "<cmd>VenvSelect<cr>" },
    -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
    { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
  },
}
