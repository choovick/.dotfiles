local mux = require("config.mux")

-- Herdr owns nav + resize. TUIOS only borrows resize (nav is tuios-nvim-navigator), because TUIOS
-- runs herdr plugin actions through its herdr emulation but has no resize hand-off of its own.
-- Under TUIOS the plugin's Alt+hjkl keys live in the TUIOS config (shell command keys), and the plugin
-- must be enabled once from a terminal OUTSIDE TUIOS: `tuios plugins enable herdr-splits`.
local function key(lhs, fn, desc)
  return {
    lhs,
    function()
      require("herdr-splits")[fn]()
    end,
    desc = desc,
  }
end

local function build_keys()
  local keys = {
    key("<M-h>", "resize_left", "Resize left (nvim/herdr)"),
    key("<M-j>", "resize_down", "Resize down (nvim/herdr)"),
    key("<M-k>", "resize_up", "Resize up (nvim/herdr)"),
    key("<M-l>", "resize_right", "Resize right (nvim/herdr)"),
  }
  if mux.is_herdr() then
    table.insert(keys, 1, key("<C-h>", "move_cursor_left", "Navigate left (nvim/herdr)"))
    table.insert(keys, 2, key("<C-j>", "move_cursor_down", "Navigate down (nvim/herdr)"))
    table.insert(keys, 3, key("<C-k>", "move_cursor_up", "Navigate up (nvim/herdr)"))
    table.insert(keys, 4, key("<C-l>", "move_cursor_right", "Navigate right (nvim/herdr)"))
  end
  return keys
end

return {
  "lmilojevicc/herdr-splits.nvim",
  -- Load inside Herdr and TUIOS (or when DOTFILES_MUX/vim.g.dotfiles_mux forces one of them)
  cond = function()
    return mux.is_herdr() or mux.is_tuios()
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
      -- TUIOS has no herdr plugin install/sync; its plugin is linked from herdr's folder.
      auto_sync_herdr = not mux.is_tuios(),
      nav_keys = { left = "<C-h>", down = "<C-j>", up = "<C-k>", right = "<C-l>" },
      resize_keys = { left = "<M-h>", down = "<M-j>", up = "<M-k>", right = "<M-l>" },
    })
  end,
  keys = build_keys(),
}
