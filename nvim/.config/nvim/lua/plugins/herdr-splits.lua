return {
  "lmilojevicc/herdr-splits.nvim",
  -- Only load inside Herdr (or when DOTFILES_MUX/vim.g.dotfiles_mux forces herdr)
  cond = function()
    return require("config.mux").is_herdr()
  end,
  event = "VeryLazy",
  -- Keep Herdr-side scripts in sync with the Neovim plugin commit after Lazy updates.
  build = ':lua require("herdr-splits").sync_herdr()',
  config = function()
    require("herdr-splits").setup({
      -- Defaults match tmux.nvim: C-hjkl navigate, A-hjkl resize
      default_amount = 0.03,
      neovim_amount = 3,
      at_edge = "wrap",
      nav_at_edge = "wrap",
      unzoom_on_nav = true,
      auto_sync_herdr = true,
      nav_keys = { left = "<C-h>", down = "<C-j>", up = "<C-k>", right = "<C-l>" },
      resize_keys = { left = "<M-h>", down = "<M-j>", up = "<M-k>", right = "<M-l>" },
    })
  end,
  keys = {
    {
      "<C-h>",
      function()
        require("herdr-splits").move_cursor_left()
      end,
      desc = "Navigate left (nvim/herdr)",
    },
    {
      "<C-j>",
      function()
        require("herdr-splits").move_cursor_down()
      end,
      desc = "Navigate down (nvim/herdr)",
    },
    {
      "<C-k>",
      function()
        require("herdr-splits").move_cursor_up()
      end,
      desc = "Navigate up (nvim/herdr)",
    },
    {
      "<C-l>",
      function()
        require("herdr-splits").move_cursor_right()
      end,
      desc = "Navigate right (nvim/herdr)",
    },
    {
      "<M-h>",
      function()
        require("herdr-splits").resize_left()
      end,
      desc = "Resize left (nvim/herdr)",
    },
    {
      "<M-j>",
      function()
        require("herdr-splits").resize_down()
      end,
      desc = "Resize down (nvim/herdr)",
    },
    {
      "<M-k>",
      function()
        require("herdr-splits").resize_up()
      end,
      desc = "Resize up (nvim/herdr)",
    },
    {
      "<M-l>",
      function()
        require("herdr-splits").resize_right()
      end,
      desc = "Resize right (nvim/herdr)",
    },
  },
}
