return {
  "folke/noice.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>m",
      "<cmd>Noice fzf<cr>",
      desc = "Message history",
    },
  },
  opts = {
    lsp = {
      -- Treesitter markdown for LSP hover/docs (blink.cmp owns its own docs UI)
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
      },
    },
    presets = {
      bottom_search = true, -- classic bottom cmdline for /
      command_palette = true, -- cmdline + popupmenu together
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = false,
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          kind = "",
        },
        opts = { skip = true },
      },
    },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      config = function()
        -- gruvbox transparent_mode leaves NotifyBackground without bg
        require("notify").setup({
          background_colour = "#000000",
        })
      end,
    },
  },
}
