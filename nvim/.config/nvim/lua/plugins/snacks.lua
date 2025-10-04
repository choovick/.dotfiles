return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    zen = {
      enabled = true,
      toggles = {
        dim = true,
        git_signs = false,
        mini_diff_signs = false,
      },
      show = {
        statusline = false,
        tabline = false,
      },
      win = {
        style = "zen",
        width = 0.90,
      },
    },
    picker = {
      enabled = true,
      win = {
        input = {
          keys = {
            ["<C-c>"] = { "close", mode = { "n", "i" } },
            ["<C-Up>"] = false,
            ["<C-Down>"] = false,
            ["<M-k>"] = "history_back",
            ["<M-j>"] = "history_forward",
          },
        },
      },
      layout = {
        layout = {
          box = "horizontal",
          width =0.95,
          min_width = 120,
          height = 0.95,
          {
            box = "vertical",
            border = "rounded",
            title = "{title} {live} {flags}",
            { win = "input", height = 1, border = "bottom" },
            { win = "list", border = "none" },
          },
          { win = "preview", title = "{preview}", border = "rounded", width = 0.5 },
        },
      },
      sources = {
        files = {
          hidden = true,
        },
        grep = {
          hidden = true,
        },
      },
    },
  },
}
