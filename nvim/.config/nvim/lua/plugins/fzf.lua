return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    -- FILES
    {
      "<leader> ",
      function()
        require("fzf-lua").files({ resume = false })
      end,
      desc = "Fuzzy find files in cwd",
    },
    {
      "<leader>ff",
      function()
        require("fzf-lua").files({
          cwd = vim.fn.expand("%:p:h"),
          resume = false,
        })
      end,
      desc = "Fuzzy find files in current buffer dir",
    },
    {
      "<leader>fF",
      function()
        require("fzf-lua").files({
          cwd = vim.fn.expand("%:p:h"),
          resume = true,
        })
      end,
      desc = "[Resume] Fuzzy find files in current buffer dir",
    },
    -- HISTORY
    {
      "<leader>fr",
      function()
        require("fzf-lua").oldfiles({
          cwd_only = true,
          include_current_session = true,
          resume = false,
        })
      end,
      desc = "Old files in current dir",
    },
    {
      "<leader>fR",
      function()
        require("fzf-lua").oldfiles()
      end,
      desc = "Fuzzy find recent files across sessions",
    },
    -- GREP --
    {
      "<leader>fs",
      function()
        require("fzf-lua").live_grep({
          cwd = vim.fn.getcwd(),
          resume = false,
        })
      end,
      desc = "Live grep with rg --glob support",
    },
    {
      "<leader>fd",
      function()
        require("fzf-lua").live_grep({
          cwd = vim.fn.expand("%:p:h"),
          resume = false,
        })
      end,
      desc = "Live grep in current buffer directory",
    },
    {
      "<leader>fD",
      function()
        require("fzf-lua").live_grep({
          cwd = vim.fn.expand("%:p:h"),
          resume = true,
        })
      end,
      desc = "[Resume] Live grep in current buffer directory",
    },
    -- BUFFER SEARCH
    {
      "<leader>fc",
      function()
        require("fzf-lua").grep_cword()
      end,
      desc = "Find string under cursor in cwd",
    },
    {
      "<leader>fl",
      function()
        require("fzf-lua").lgrep_curbuf({ resume = true })
      end,
      desc = "Live grep in current buffer",
    },
    -- BUFFER LISTS
    {
      "<leader>fb",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "Select buffer",
    },
    {
      "<leader>fL",
      function()
        require("fzf-lua").blines()
      end,
      desc = "Search in current buffer",
    },
  },
  config = function()
    -- https://github.com/ibhagwan/fzf-lua?tab=readme-ov-file#default-options
    -- calling `setup` is optional for customization
    local fzf = require("fzf-lua")
    local actions = fzf.actions
    fzf.setup({
      fzf_opts = {
        ["--history"] = vim.fn.stdpath("data") .. "/fzf-lua-history",
      },
      keymap = {
        fzf = {
          -- sets filtered items to quickfix list
          ["enter"] = "accept",
          ["ctrl-a"] = "select-all",
          ["ctrl-t"] = "toggle-all",
        },
      },
      grep = {
        rg_opts = "--hidden --follow --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
      },
      files = {
        actions = {
          ["ctrl-g"] = { actions.toggle_ignore },
          ["ctrl-h"] = { actions.toggle_hidden },
        },
      },
      actions = {
        ["files"] = {
          -- dont want to open multiple files in quickfix list, just edit them all on multiselect
          ["enter"] = actions.file_edit,
          ["ctrl-q"] = actions.file_sel_to_qf,
        },
      },
      winopts = {
        fullscreen = true,
        preview = {
          -- default = "bat",
          horizontal = "right:40%",
        },
      },
    })
  end,
}
