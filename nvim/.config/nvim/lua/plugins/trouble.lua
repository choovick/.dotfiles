return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
  -- version = "v2.*",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    -- { "<leader>xx", "<cmd>TroubleToggle<CR>", desc = "Open/close trouble list" },
    -- { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Open trouble workspace diagnostics" },
    -- { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", desc = "Open trouble document diagnostics" },
    -- { "<leader>xq", "<cmd>Trouble quickfix<CR>", desc = "Open trouble quickfix list" },
    -- { "<leader>q", "<cmd>Trouble quickfix<CR>", desc = "Open trouble quickfix list" },
    -- { "<leader>xl", "<cmd>TroubleToggle loclist<CR>", desc = "Open trouble location list" },
    -- { "<leader>xt", "<cmd>TodoTrouble<CR>", desc = "Open todos in trouble" },
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>xs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>xl",
      "<cmd>Trouble lsp toggle focus=true win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xq",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
    -- lsp references
    {
      "<leader>xR",
      "<cmd>Trouble lsp_references<cr>",
      desc = "LSP References (Trouble)",
    },
    -- lsp declarations
    {
      "<leader>xd",
      "<cmd>Trouble lsp_definitions<cr>",
      desc = "LSP Definitions (Trouble)",
    },
    -- lsp type definitions
    {
      "<leader>xt",
      "<cmd>Trouble lsp_type_definitions<cr>",
      desc = "LSP Type Definitions (Trouble)",
    },
    -- close trouble
    {
      "<leader>xc",
      '<cmd>lua require("trouble").close()<CR>',
      desc = "Close Trouble",
    },
  },
}
