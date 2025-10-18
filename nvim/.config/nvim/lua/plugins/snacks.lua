return {
  "folke/snacks.nvim",
  priority = 1000,
  enabled = false,
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
  keys = {
    -- Files
    {
      "<leader> ",
      function()
        require("snacks").picker.files({
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
            },
          },
        })
      end,
      desc = "Fuzzy find files in cwd",
    },
    {
      "<leader>ff",
      function()
        require("snacks").picker.files({
          cwd = vim.fn.expand("%:p:h"),
        })
      end,
      desc = "Fuzzy find files in current buffer dir",
    },
    -- Recent files
    {
      "<leader>fr",
      function()
        require("snacks").picker.recent({
          filter = {
            cwd = true, -- Only show files from current working directory
          },
          include_current_session = true,
        })
      end,
      desc = "Old files in current dir",
    },
    {
      "<leader>fR",
      function()
        require("snacks").picker.recent()
      end,
      desc = "Fuzzy find recent files across sessions",
    },
    -- Grep/Search
    {
      "<leader>fs",
      function()
        require("snacks").picker.grep({
          cwd = vim.fn.getcwd(),
        })
      end,
      desc = "Live grep with rg --glob support",
    },
    {
      "<leader>fd",
      function()
        require("snacks").picker.grep({
          cwd = vim.fn.expand("%:p:h"),
        })
      end,
      desc = "Live grep in current buffer directory",
    },
    {
      "<leader>fc",
      function()
        require("snacks").picker.grep({ search = vim.fn.expand("<cword>") })
      end,
      desc = "Find string under cursor in cwd",
    },
    {
      "<leader>fl",
      function()
        require("snacks").picker.grep_buffers()
      end,
      desc = "Live grep in current buffer",
    },
    -- Buffers and lines
    {
      "<leader>fb",
      function()
        require("snacks").picker.buffers()
      end,
      desc = "Select Buffer",
    },
    {
      "<leader>fL",
      function()
        require("snacks").picker.lines()
      end,
      desc = "Search in current Buffer",
    },
    -- Commands and history
    {
      ";",
      function()
        require("snacks").picker.command_history()
      end,
      desc = "Command history",
      mode = { "n", "v" },
    },
    {
      "<leader>:",
      function()
        require("snacks").picker.commands()
      end,
      desc = "Snacks picker commands",
      mode = { "n", "v" },
    },
  },
}
