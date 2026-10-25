return {
  "Tim4c/tuios-nvim-navigator",
  -- Only load inside TUIOS (or when DOTFILES_MUX/vim.g.dotfiles_mux forces tuios).
  -- Needs `appearance.nvim_navigation = true` in the TUIOS config (set in tuios/ in this repo).
  cond = function()
    return require("config.mux").is_tuios()
  end,
  event = "VeryLazy",
  config = function()
    require("tuios-nvim-navigator").setup({
      -- Must match terminal_focus_* in the TUIOS config (C-hjkl, same as tmux/Herdr).
      keymaps = { left = "<C-h>", down = "<C-j>", up = "<C-k>", right = "<C-l>" },
    })
  end,
}
