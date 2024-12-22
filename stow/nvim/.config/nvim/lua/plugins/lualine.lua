return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "kyazdani42/nvim-web-devicons" },
    { "cormacrelf/dark-notify" },
  },
  lazy = false,
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count

    -- configure lualine with modified theme
    lualine.setup({
      options = {
        theme = "auto",
      },
      sections = {
        lualine_c = {
          {
            "filename",
            path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
          },
        },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
      },
      inactive_sections = {
        lualine_c = {
          {
            "filename",
            path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
          },
        },
      },
    })

    -- Delay the execution of the update function by 1 second
    vim.defer_fn(function()
      -- run command: lua require('dark_notify').update()
      require("dark_notify").update()
    end, 1000)
  end,
}
