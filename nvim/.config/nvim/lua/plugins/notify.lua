-- gruvbox transparent_mode clears hl backgrounds; notify needs an explicit colour
-- for opacity compositing (see NotifyBackground / background_colour docs).
return {
  "rcarriga/nvim-notify",
  priority = 900,
  config = function()
    require("notify").setup({
      background_colour = function()
        return vim.o.background == "light" and "#fbf1c7" or "#282828"
      end,
    })
  end,
}
