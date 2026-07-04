return {
  "roobert/search-replace.nvim",
  keys = {
    -- :%s/// templates under <leader>ar (actions → replace)
    {
      "<leader>ars",
      "<cmd>SearchReplaceSingleBufferSelections<cr>",
      desc = "Replace: pick target (word/expr/…)",
    },
    {
      "<leader>arr",
      "<cmd>SearchReplaceSingleBufferOpen<cr>",
      desc = "Replace in buffer (:s with flags)",
    },
    {
      "<leader>arw",
      "<cmd>SearchReplaceSingleBufferCWord<cr>",
      desc = "Replace word under cursor",
    },
    {
      "<leader>arW",
      "<cmd>SearchReplaceSingleBufferCWORD<cr>",
      desc = "Replace WORD under cursor",
    },
    {
      "<leader>are",
      "<cmd>SearchReplaceSingleBufferCExpr<cr>",
      desc = "Replace expression under cursor",
    },
    {
      "<leader>arf",
      "<cmd>SearchReplaceSingleBufferCFile<cr>",
      desc = "Replace file path under cursor",
    },
    {
      "<leader>arbo",
      "<cmd>SearchReplaceMultiBufferOpen<cr>",
      desc = "Replace in quickfix buffers",
    },
    {
      "<leader>arv",
      "<cmd>SearchReplaceSingleBufferVisualSelection<cr>",
      mode = "v",
      desc = "Replace visual selection in buffer",
    },
    {
      "<leader>arV",
      "<cmd>SearchReplaceVisualSelection<cr>",
      mode = "v",
      desc = "Replace within visual selection",
    },
  },
  config = function()
    require("search-replace").setup({
      -- gcI: global, confirm each match, no case fold
      default_replace_single_buffer_options = "gcI",
      default_replace_multi_buffer_options = "egcI",
    })
    -- live preview while typing :s/old/new
    vim.o.inccommand = "split"
  end,
}
