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
      win = {
        style = "zen",
        width = 0,
      },
    },
    picker = {
      enabled = true,
      formatters = {
        file = {
          filename_first = true, -- display filename before the file path
          truncate = 200, -- truncate the file path to (roughly) this length
          filename_only = false, -- only show the filename
          icon_width = 2, -- width of the icon (in characters)
          git_status_hl = true, -- use the git status highlight group for the filename
        },
      },
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
          width = 0.95,
          min_width = 120,
          height = 0.95,
          {
            box = "vertical",
            border = "rounded",
            title = "{title} {live} {flags}",
            { win = "input", height = 1, border = "bottom" },
            { win = "list", border = "none" },
          },
          { win = "preview", title = "{preview}", border = "rounded", width = 0.3 },
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
